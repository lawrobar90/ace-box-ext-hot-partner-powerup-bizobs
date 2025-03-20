## Lab 2: event ingestion and analytics

This lab will show you how to configure event ingestion.

### 2.1 Allow outbound connections

1. *Open* "**Settings Classic**" 
1. *Open* the "**Preferences**" menu group
1. *Click* on "**Limit outbound connections**"
1. *Click* on "**Add item**"
1. For **Allow outbound connections**, paste the following rule:
      ```
       *.live.dynatrace.com
      ```
1. At the bottom of the screen, click "*Save changes*"


### 2.2 **Create an access token**

1. Open the "Access Tokens" app
1. Click on "Generate new token"
1. Give your token any name
1. For "Scopes", search for "Ingest bizevents"
1. Mark the checkbox
1. At the bottom of the screen, click on "Generate token"
1. Copy the token value as it will not be shown again

### 2.3 Import workflow

1. ***Download* the workflow template from the "Materials" tab in the DTU Course
1. In Dynatrace, open the *Workflows* app
1. At the top right, click "Upload"
1. Select the downloaded file
1. Click "Import"    

### 2.4 **Edit the workflow** 

1. At the top right of the screen, click on "Settings"
1. Toggle the "Workflow admin" button
1. Do the following for each of the three actions: "json", "cloudevent" and "cloudevent_batch"
    - For the "URL" value, edit where you see `<PASTE ENV ID HERE>` and paste your Dynatrace Environment ID 
    - For the "authorization" header value, edit where you see `<PASTE TOKEN HERE>` and paste your token (make sure you keep "Api-Token " before it)
1. Click "Run"
2. Click "Save & Run"
3. Click "Allow & Run"

### 2.5 Validate event ingestion

1.	***Run* the following query:**

      ```
      fetch bizevents 
      | filter event.provider == "Perform_2025"
      | fields event.type, amount, price
      ```

You should see these 3 event types:
- api-ingest.json
- api-ingest.cloudevent
- api-ingest.cloudevent_batch

### Bonus: edit the payload for each workflow action to include different attributes
