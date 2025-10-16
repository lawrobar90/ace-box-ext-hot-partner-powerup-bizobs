## Lab 3: how to visualize business insights

This lab will help you understand what business analytics is trying to achieve for an end goal.

### 3.1 Creating your Business Flow
1. *Open* the **Business Flow** app
1. *Click* '**+ New Flow**'
1. *Click* on the title to change its name to:
      ```
      Customer Journey Flow
      ```
1. At the right of the screen, see the title "Step 1" and click on it
1. *Rename* the step to:
      ```
      Journey Step 1
      ```
1. Click "Add Event"
1. For the **Events** dropdown, *select*:
      ```
      com.partner-powerup-bizobs.step1-completed
      ```
1. Click "Save changes"

### 3.2 Adding Subsequent Steps
1. At the center of the screen, hover over the "Order Credit Card" step
1. A "+" sign should appear just below it, click on it to add a new step
1.	*Rename* this step to
      ```
  	   Journey Step 2
      ```
1.	For the **Events** dropdown, *select*:
      ```
      com.partner-powerup-bizobs.step2-completed
      ```
1.	For the **Business Exception** dropdown, *select*:
      ```
      com.partner-powerup-bizobs.step-error
      ```

### 3.3 Adding Final Steps
1. At the center of the screen, hover over the "Credit Card manufactured" step
1. A "+" sign should appear just below it, click on it to add a new step
1.	*Rename* this step to
      ```
      Journey Step 3
      ```
1.	For the **Events** dropdown, *select*:
      ```
      com.partner-powerup-bizobs.step3-completed
      ```
1. At the center of the screen, hover over the "Credit Card shipped" step
1. A "+" sign should appear just below it, click on it to add a new step
1.	*Rename* this step to
      ```
      Journey Step 4
      ```
9.	*Drop down* **Events**, *select*
      ```
      com.partner-powerup-bizobs.step4-completed
      ```

### 3.4 Adding Configuration and KPI’s
1.	At the top right, in Global Settings change **Correlation ID** to:
      ```
      orderId
      ```
3.	*Change* **Mapping event** to:
      ```
      com.partner-powerup-bizobs.step2-completed
      ```
4.	*Change* **Mapping Attribute** to:
      ```
      revenue
      ```

*Click* **Validate & Save** and then **View Flow**
