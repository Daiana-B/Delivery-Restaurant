USE delivery_restaurant
GO

--Checking for duplicates

--sku
SELECT sku, COUNT(*) 
FROM item 
GROUP BY sku 
HAVING COUNT(*) > 1;

--address
WITH dupl_rn AS(
SELECT *, 
ROW_NUMBER() OVER (PARTITION BY delivery_address1, delivery_address2, delivery_city, delivery_zipcode ORDER BY add_id) AS rn
FROM address)
SELECT * FROM dupl_rn WHERE rn > 1
--2 duplicate records were found
--updating orders to change duplicate add_id on initial add_id
WITH CTE AS (
    SELECT add_id, 
           MIN(add_id) OVER (PARTITION BY delivery_address1, delivery_city, delivery_zipcode) AS new_add_id
    FROM address
)
UPDATE o
SET add_id = c.new_add_id
FROM orders o
JOIN CTE c ON o.add_id = c.add_id;
--deleting duplicate entries
WITH dupl_rn AS(
SELECT *, 
ROW_NUMBER() OVER (PARTITION BY delivery_address1, delivery_address2, delivery_city, delivery_zipcode ORDER BY add_id) AS rn
FROM address)
DELETE FROM address WHERE add_id IN (SELECT add_id FROM dupl_rn WHERE rn > 1)

--recipe
WITH dupl_rn AS(
SELECT *, 
ROW_NUMBER() OVER (PARTITION BY recipe_id, ing_id ORDER BY row_id) AS rn
FROM recipe)
SELECT * FROM dupl_rn WHERE rn > 1

--orders
WITH dupl_ord AS(
SELECT *, 
ROW_NUMBER() OVER (PARTITION BY order_id, item_id ORDER BY row_id) AS rn
FROM orders)
SELECT * FROM dupl_ord WHERE rn > 1
ORDER BY 2

--inventory
SELECT ing_id, COUNT(*) 
FROM inventory 
GROUP BY ing_id 
HAVING COUNT(*) > 1;
--ING001 has 2 indentical rows
DELETE FROM inventory WHERE inv_id = 31

--check that all item_ids in orders exist in item
SELECT o.item_id 
FROM orders o
LEFT JOIN item i ON o.item_id = i.item_id
WHERE i.item_id IS NULL;

--a query for further visualization for order's dashboard
SELECT order_id, item_price, quantity, item_cat, item_name, created_at, delivery_address1, delivery_zipcode
FROM orders o
LEFT JOIN item i ON o.item_id = i.item_id
LEFT JOIN address a ON o.add_id = a.add_id 

--request to track stock balances
SELECT ing_id, ing_name, inv_quantity-SUM(ord_quantity*rec_quantity) AS stock_level
FROM
(SELECT inv.ing_id, ing.ing_name, inv.quantity AS inv_quantity, r.quantity AS rec_quantity, SUM(o.quantity) AS ord_quantity
FROM inventory inv
LEFT JOIN recipe r ON inv.ing_id = r.ing_id
LEFT JOIN ingredient ing ON inv.ing_id = ing.ing_id
LEFT JOIN item i ON r.recipe_id = i.sku
LEFT JOIN orders o ON o.item_id = i.item_id
WHERE created_at > updated_at
GROUP BY inv.ing_id, ing.ing_name, inv.quantity, r.quantity) s1
GROUP BY ing_id, ing_name, inv_quantity
ORDER BY 3
