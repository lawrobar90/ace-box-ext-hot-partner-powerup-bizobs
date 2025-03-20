## Lab 3: how to visualize business insights

This lab will help you understand what business analytics is trying to achieve for an end goal.

### 3.1 Creating your Business Flow
1.	*Open* the **Business Flow** app
1.	*Click* '**+ Business Flow**'
1. *Click* on the pencil icon next to "Configuration"
1. For "Name", copy and paste:
      ```
      Credit Card order
      ```
1. Click on "Save"
1. At the right of the screen, see the title "Step 1" and click on it
1.	*Rename* the step to:
      ```
      Order Credit Card
      ```
1.	For the **Events** dropdown, *select*:
      ```
      com.easytrade.order-credit-card
      ```

### 3.2 Adding Subsequent Steps
1. At the center of the screen, hover over the "Order Credit Card" step
1. A "+" sign should appear just below it, click on it to add a new step
1.	*Rename* this step to
      ```
  	   Credit Card manufactured
      ```
1.	For the **Events** dropdown, *select*:
      ```
      com.easytrade.update-credit-card-status.created
      ```
1.	For the **Business Exception** dropdown, *select*:
      ```
      com.easytrade.update-credit-card-status.error
      ```

### 3.3 Adding Final Steps
1. At the center of the screen, hover over the "Credit Card manufactured" step
1. A "+" sign should appear just below it, click on it to add a new step
1.	*Rename* this step to
      ```
      Credit Card shipped
      ```
1.	For the **Events** dropdown, *select*:
      ```
      com.easytrade.update-credit-card-status.shipped
      ```
1. At the center of the screen, hover over the "Credit Card shipped" step
1. A "+" sign should appear just below it, click on it to add a new step
1.	*Rename* this step to
      ```
      Credit Card delivered
      ```
9.	*Drop down* **Events**, *select*
      ```
      com.easytrade.update-credit-card-status.delivered
      ```

### 3.4 Adding Configuration and KPI’s
1.	At the top right, in Global Settings change **Correlation ID** to:
      ```
      orderId
      ```
3.	*Change* **Mapping event** to:
      ```
      com.easytrade.update-credit-card-status.created
      ```
4.	*Change* **Mapping Attribute** to:
      ```
      revenue
      ```

*Click* **Validate & Save** and then **View Flow**
