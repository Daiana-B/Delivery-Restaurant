USE delivery_restaurant
GO

--a query for further visualization for order's dashboard
SELECT order_id, item_price, quantity, item_cat, item_name, created_at, delivery_address1, delivery_zipcode
FROM orders o
LEFT JOIN item i ON o.item_id = i.item_id
LEFT JOIN address a ON o.add_id = a.add_id 

----a query for further visualization for stock's dashboard
SELECT 
item_id, 
sku, 
item_name, 
ing_id, 
ing_name, 
recipe_quantity, 
order_quantity*recipe_quantity AS ordered_weight, 
ing_price/ing_weight AS ing_cost
FROM
(SELECT o.item_id, i.sku, i.item_name, r.ing_id, ing.ing_name, r.quantity AS recipe_quantity, SUM(o.quantity) AS order_quantity, ing.ing_weight, ing.ing_price
FROM orders o
LEFT JOIN item i ON o.item_id = i.item_id
LEFT JOIN recipe r ON i.sku = r.recipe_id
LEFT JOIN ingredient ing ON r.ing_id = ing.ing_id
GROUP BY o.item_id, i.sku, i.item_name, r.ing_id, ing.ing_name, r.quantity, ing.ing_weight, ing.ing_price) s1