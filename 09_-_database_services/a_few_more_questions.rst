A couple other questions. You don't have to answer any of them. Just putting it out there while I still remember.
What is buisness intelligence
What is analytics
What's the most secure way to connect to RDS? (I'm reading about RDS proxy right now, which seems like the answer.)

Paloma Vilceus
:speech_balloon:  27 minutes ago
Hey Chris,

Business Intelligence
Business intelligence refers to the process of collecting, analyzing, and presenting data in a way that helps businesses make informed decisions. It involves gathering information from various sources, such as sales records, customer data, and market trends, and using specialized tools to transform that raw data into meaningful insights. These insights can help companies understand their performance, identify patterns, spot opportunities, and address challenges.

Business Intelligence tools are able to take data from different sources and provide Data Visualization/Reporting  (interactive dashboards, charts, graphs). Some popular ones are Tableau and Power BI

Let's take the example of a Disney Store and see how business intelligence can be applied.

Sales Analysis: Business intelligence can analyze the sales data of a Disney Store to identify trends, such as which products are popular, which ones are not performing well, and how sales vary across different regions or time periods. This information can help the store optimize its inventory, focus on high-demand items, and make strategic pricing decisions.
Customer Segmentation: By analyzing customer data, such as demographics, purchase history, and preferences, business intelligence can help the Disney Store segment its customers into different groups. For example, it can identify loyal customers, occasional visitors, or specific target markets. This segmentation allows the store to tailor its marketing efforts, create personalized offers, and enhance customer experiences.

Inventory Management: Business intelligence can analyze inventory data to optimize stock levels and reduce costs. It can identify slow-moving or overstocked items, forecast demand based on historical data and market trends, and suggest efficient reorder points. By having the right products in stock at the right time, the Disney Store can minimize stockouts and avoid tying up excess capital in inventory.

Market Analysis: Business intelligence can gather and analyze external data, such as competitor information, market trends, and consumer behavior, to provide insights into the broader market landscape. For example, it can track the performance of Disney merchandise in comparison to other brands, monitor emerging trends in the entertainment industry, or identify new market opportunities.
Performance Tracking: Business intelligence can generate real-time reports and dashboards that track key performance indicators (KPIs) for the Disney Store, such as sales revenue, foot traffic, conversion rates, and customer satisfaction. These insights allow management to monitor performance, identify areas for improvement, and make data-driven decisions to drive business growth.
(edited)
:grin:
1

Paloma Vilceus
:speech_balloon:  26 minutes ago
This is a cool introductory article from Tableau https://www.tableau.com/learn/articles/business-intelligence
TableauTableau
Business intelligence: A complete overview
Business intelligence (BI) uses business analytics, data mining, data visualization, and data tools to help organizations make better data-driven decisions.

Paloma Vilceus
:speech_balloon:  < 1 minute ago
Analytics is used to extract meaningful insights from data that can drive decision making and strategy formulation.
There are four types of analytics you can leverage depending on the data you have and the type of knowledge you’d like to gain.
1. Descriptive analytics looks at data to examine, understand, and describe something that’s already happened. --->  Biz Intelligence
2. Diagnostic analytics goes deeper than descriptive analytics by seeking to understand the “why” behind what happened.
3. Predictive analytics relies on historical data, past trends, and assumptions to answer questions about what will happen in the future.
4. Prescriptive analytics identifies specific actions an individual or organization should take to reach future targets or goals

https://www.splunk.com/en_us/blog/learn/data-analytics.htmlSplunk-BlogsSplunk-Blogs
Data Analytics 101: The 4 Types of Data Analytics Your Business Needs
Data analytics is a whole world of information that you can glean meaning from. See the 4 types of data analytics any business practice needs today.

Paloma Vilceus
:speech_balloon:  1 hour ago
Analytics is used to extract meaningful insights from data that can drive decision making and strategy formulation.
There are four types of analytics you can leverage depending on the data you have and the type of knowledge you’d like to gain.
1. Descriptive analytics looks at data to examine, understand, and describe something that’s already happened. --->  Biz Intelligence
2. Diagnostic analytics goes deeper than descriptive analytics by seeking to understand the “why” behind what happened.
3. Predictive analytics relies on historical data, past trends, and assumptions to answer questions about what will happen in the future.
4. Prescriptive analytics identifies specific actions an individual or organization should take to reach future targets or goals
https://www.splunk.com/en_us/blog/learn/data-analytics.html
Splunk-BlogsSplunk-Blogs
Data Analytics 101: The 4 Types of Data Analytics Your Business Needs
Data analytics is a whole world of information that you can glean meaning from. See the 4 types of data analytics any business practice needs today.
Mar 2nd

Paloma Vilceus
:speech_balloon:  17 minutes ago
What's the most secure way to connect to RDS? (I'm reading about RDS proxy right now, which seems like the answer.)
The RDS Proxy improves the security of RDS in several ways:
Since it's a layer that sits in between the client and the DB it increases the scalability by managing concurrent connections (pooling). This prevents connection overload and minimizes the risk of a DDOS attack
the proxy adds support for IAM database  authentication (get all the benefits of using tokens/roles vs a long lived user/password).
You can centralize the creation/monitoring of DB user accounts accounts bc now you don't need to create local users on the DB instance
Bc you are using roles/tokens you don't need to hardcode password in the application code
RDS Proxy can enforce SSL/TLS encryption for connections, ensuring that data transmitted between your application and the RDS database remains encrypted. This protects against eavesdropping and data interception during transit.
RDS Proxy provides detailed monitoring and logging capabilities, allowing you to capture and analyze database traffic.
Remember there are other things you can do to improve the security of RDS
Isolate the RDS Instance in a private subnet or purpose built subnet. You can even use NACLs (in addition to SG) in this case to limit traffic at the subnet level
Enable logging
Encrypt connections to the DB Instance
image.png
 
image.png
