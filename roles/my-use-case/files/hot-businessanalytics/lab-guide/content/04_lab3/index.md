## Lab 3: Creating a Business Flow
This lab will help you understand what business analytics is trying to achieve for an end goal.

### 3.1 Creating your Business Flow
1.	*Navigate* to **Apps**
2.	*Find* and *click* on **Business Flow**
3.	*Click* '**+ Business Flow**'
4.	*Select* '**Configuration**' and *give* the Business Flow an **identifiable name**
5.	*Click* on **Step 1**, and *rename* the step to:
```
Order Credit Card
```
8.	*Drop down* **Events**, *select*:
```
com.easytrade.order-credit-card
```

### 3.2 Adding Subsequent Steps
1.	Under the **first step**, *click* '**+ Add Step**'
2.	*Rename* this step to
   ```
  	Credit Card manufactured
```
4.	*Drop down* **Events**, *select*:
   ```
com.easytrade.update-credit-card-status.created
```
6.	*Add* a **second Event** into **Business Exceptions**:
```
com.easytrade.update-credit-card-status.error
```

### 3.3 Adding Final Steps
1.	Under the **second step**, *click* '**+ Add Step**'
2.	*Rename* this step to '**Credit Card shipped**'
3.	*Drop down* **Events**, *select* '**com.easytrade.update-credit-card-status.shipped**'
4.	Under the **third step**, *click* '**+ Add Step**'
5.	*Rename* this step to '**Credit Card delivered**'
6.	*Drop down* **Events**, *select* '**com.easytrade.update-credit-card-status.delivered**'

### 3.4 Adding Configuration and KPI’s
1.	At the top, *click* '**Settings**'
2.	*Change* **Select event** to '**com.easytrade.order-credit-card**'
3.	*Change* *correrlation ID* to '**orderId**'

**View the Business Flow in the instructor's environment**
