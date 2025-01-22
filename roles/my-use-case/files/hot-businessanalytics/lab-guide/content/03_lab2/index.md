## Lab 2: Configuring Event Ingestion    

This lab will show you how to configure event ingestion.

### 2.1 Import Workflow
 
1. **Limit outbound connections**

```
*.live.dynatrace.com
```
   

2. ***Download* the workflow template from DTU and import it to the Environment**

    - Open Workflows app 

    - Click Upload
    
    - Select the template file and click Open

3. **Create an access token**

    - Open the Access Token app

    - Create a token with “Ingest bizevents” permission 

    - Make sure you copy the token value 

4. **Enable workflow admin mode**

5. **Edit the workflow** 

    - Open the uploaded workflow 

    - Click on each of the three actions - JSON, Cloudevent, & Cloudevent Batch

    - Edit the environment ID 

            <PASTE ENV ID HERE>

    - Paste the token in the “Authorization” field

            <PASTE TOKEN HERE> 

    - Change Workflow settings Actor 

6. **Run the workflow** 

### Bonus: edit the payload to include different attributes

### 2.2 Validate event ingestion
1.	***Run* the following query:**

```
fetch bizevents 
| filter event.provider == "Perform_2025"
```

**Four events should be there**
