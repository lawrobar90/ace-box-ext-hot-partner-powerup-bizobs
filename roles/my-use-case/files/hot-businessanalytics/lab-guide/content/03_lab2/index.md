## Lab 3: how to visualize business insights

This lab will help you understand what business analytics is trying to achieve for an end goal.

### 3.1 Finding your journey flow

1.	*Open* "**Notebooks**"
1.	*Create* a **new notebook**
1.	*Click* on the "**+**" to add a **new section**
1.	*Click* on "**DQL**"
1.	Copy and *paste* the *query*:

      ```
      Fetch Bizevents
      | filter isNotNull(rsBody) and isNotNull(rqBody)
      | filter isNotNull(json.additionalFields) and isNotNull(json.stepIndex)
      | filter json.companyName == "Companyname" //Include your companyName in "" from the BizObs app
      | summarize count(), by:{event.type,json.stepName, json.stepIndex}
      | sort json.stepIndex asc
      ```

1. This DQL will show you the order of your Customer Journey in a simple context. The journey is from StepIndex 1 > 6, and can include exceptions where applicable

### 3.2 Creating your Business Flow
1. *Open* the **Business Flow** app
1. *Click* '**+ New Flow**'
1. *Click* on the title to change its name to:
      ```
      **CustomerName** Journey Flow
      ```
1. At the right of the screen, see the title "Step 1" and click on it
1. *Rename* the step to **Name of your event.type with StepIndex of 1**
      
1. Click "Add Event"
1. For the **Events** dropdown, *select*:
      ```
      Name of your event.type with StepIndex of 1
      ```
1. Click "Add business exception"
1. For the **Events** dropdown, *select*:
      ```
      Name of your event.type with StepIndex of 1, but also include exception at the end
      ```
1. Click "Save changes"
***You may not have an exception event yet, keep running the journey until all your steps have completed successfully and failed as well***


### 3.3 Adding Subsequent Steps
1. At the center of the screen on your first step, hover over the step
1. A "+" sign should appear just below it, click on it to add a new step
1.	*Rename* this step to
      ```
      Name of your event.type with StepIndex of 2
      ```
1.	For the **Events** dropdown, *select*:
      ```
      Name of your event.type with StepIndex of 2
      ```
1.	For the **Business Exception** dropdown, *select*:
      ```
      Name of your event.type with StepIndex of 2, but also include exception at the end
      ```
1. **Now add all the other subsequent 4 steps for your journey**


### 3.4 Adding Configuration and KPI’s
1.	At the top right, in Global Settings change **Correlation ID** to:
      ```
      json.correlationId
      ```
3.	*Change* **Mapping event** to:
      ```
      Pick an event that has an item cost associated. If you don't have one, then leave it blank
      ```
4.	*Change* **Mapping Attribute** to:
      ```
      For the event you selected, find the price if applicable and select it
      ```

*Click* **Save vhanges** and then **Exit editing**
