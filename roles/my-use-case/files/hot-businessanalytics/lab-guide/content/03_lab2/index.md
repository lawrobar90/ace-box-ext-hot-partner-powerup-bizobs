## Lab 2: Configuring Event Ingestion    

This lab will show you how to configure event ingestion.

### 2.1 Import Workflow
 
1.	*Download* the **workflow file** and *import* it to the Environment
    - *Open* **Workflows app**
    - *Click* **Upload**
2.	*Create* an **access token**
      - *Open* the **Access Token** page
      - *Create* a token with “Ingest bizevents” permission
      - Make sure you *copy* the **token value**
3.	*Edit* the **workflow**
     - *Open* the uploaded **workflow **
     - *Click* on each of the **three actions**
     - *Paste* the **token** in the “**Authorization**” field
4.	*Run* the **workflow**
5.	**Bonus**: *edit* the **payload** to *include* **different attributes**

### 2.2 Validate event ingestion
1.	*Run* the following **query**:

```
fetch bizevents 
| filter event.provider == "com.dynatrace.perform"
```

**Four events should be there**
