use project_guvi;

# 1.Identify Drop-off Points
SELECT Stage, Action, COUNT(*) AS Action_Count
FROM customer_journey
GROUP BY Stage, Action
ORDER BY Action_Count DESC;
#Drop-off points - Total 20 customers 14 cutomers drop-off their purchase at the checkout stage and 6 made their purchase.

# 2. Calculate Average Duration per Stage
SELECT Stage, AVG(Duration) AS AvgDuration
FROM customer_journey
WHERE Duration IS NOT NULL
GROUP BY Stage
ORDER BY AvgDuration DESC;
# Average duration in each stage,
# productpage = 182.7
# Homepage = 160.5
# checkout = 45
# Most of them spend more seconds in Homepage.

#3. Identify Highest-Rated Products
SELECT a.ProductID,b.productname,AVG(Rating) AS AvgRating
FROM customer_reviews as a inner join products as b on a.productID=b.productID
GROUP BY a.ProductID,b.productname
ORDER BY AvgRating DESC
LIMIT 5;
# ProductID 8 (Football Helmet),productID 19 (Hockey stick),ProductID 18 (Volleyball) are the highest-rated products.

#4. Identify Lowest-Rated Products
SELECT a.ProductID,b.productname, AVG(Rating) AS AvgRating
FROM customer_reviews as a inner join products as b on a.productID=b.productID
GROUP BY a.ProductID,b.productname
ORDER BY AvgRating ASC
LIMIT 3;
# ProductID 7 (Basketball),productID 4(Dumbbells),productID 12(Ice Skates) are the lowest-rated products.

#Marketing Effectiveness (SQL):

# 5.Find Best Performing Marketing Channels
SELECT ContentType, AVG(CAST(SUBSTRING_INDEX(ViewsClicksCombined, '-', -1) AS UNSIGNED)) AS Avg_Clicks
FROM engagement_data
GROUP BY ContentType
ORDER BY Avg_Clicks DESC;
# Best Performing Content Types (Based on Click-Through Rate - CTR)
# Socialmedia got 520.7 Avg_clicks.

# 6.Find Best Performing Campaigns
SELECT CampaignID, SUM(Likes) AS Total_Likes, SUM(CAST(SUBSTRING_INDEX(ViewsClicksCombined, '-', -1) AS UNSIGNED)) AS Total_Clicks
FROM engagement_data
GROUP BY CampaignID
ORDER BY Total_Clicks DESC
LIMIT 5;

# 7.Analyze Purchases by Gender
SELECT c.Gender, COUNT(j.CustomerID) AS Purchase_Count
FROM customers c
JOIN customer_journey j ON c.CustomerID = j.CustomerID
WHERE j.Action = 'Purchase'
GROUP BY c.Gender;

# 8. Join Customers, Geography & Purchases (to analyze location-based sales)
SELECT c.CustomerName, g.Country, g.City, COUNT(j.CustomerID) AS Purchase_Count
FROM Customers c
JOIN Geography g ON c.GeographyID = g.GeographyID
JOIN Customer_Journey j ON c.CustomerID = j.CustomerID
WHERE j.Action = 'Purchase'
GROUP BY c.CustomerName, g.Country, g.City
ORDER BY Purchase_Count DESC;

# 9.Join Customers, Customer Journey & Products (to link actions with product details)
SELECT c.CustomerID, c.CustomerName, p.ProductName, j.Stage, j.Action, j.VisitDate
FROM Customers c
JOIN Customer_Journey j ON c.CustomerID = j.CustomerID
JOIN Products p ON j.ProductID = p.ProductID;

# 10.Join Marketing Engagement Data with Products (to analyze campaign effectiveness)
SELECT e.EngagementID, e.ContentType, e.Likes, e.ViewsClicksCombined, p.ProductName
FROM Engagement_Data e
JOIN Products p ON e.ProductID = p.ProductID;
