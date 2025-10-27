## Lab 1: basic configuration and exploration 

This lab will show you how to *create* and *validate* **business rules**. 

### 1.1 OneAgent rule Configuration

##### Configure
1.	*Open* "**Settings Classic**"
1.	*Open* "**Business Analytics**" menu group
1.	*Click* on "**OneAgent**"
1.	*Click* on "**Add new capture rule**" on the **incoming** tab
1.	For field "**Rule name**", *copy* and *paste*:
      ```
      BizObs App
      ```

##### Configure Trigger

1.	*Click* on "**Add trigger**"
1.	For "**Data source**", *select* "**Request - Path**"
1.	For "**Operator**", *select* "**starts with**"
1.	For "**Value**", *copy* and *paste*:
      ```
      /process
      ```

##### Configure metadata (provider)

1.	For "**Event provider data source**", *select* "**Fixed value**"
1.	For "**Data source**", make sure that "**Request - Body**" is *selected*
1.	For "**Field name**" and "**Path**", *copy* and *paste*:
      ```
      companyName
      ```

##### Configure metadata (type)

1.	For "**Event type data source**", *select* "**Fixed value**"
1.	For "**Data source**", make sure that "**Request - Body**" is *selected*
1.	For "**Field name**" and "**Path**", *copy* and *paste*:
      ```
      stepName
      ```

##### Configure additional data (price)

1.	*Click* on "**Add data field**"
1.	For "**Data source**", make sure that "**Request - Body**" is *selected*
1.	For "**Field name**", *copy* and *paste*:
      ```
      rqBody
      ```
1.	For "**Path**", *copy* and *paste*:
      ```
      *
      ```

**At the bottom of the screen, click "Save changes"**

### 1.2 Service Naming Rules

##### Create a Service Naming Rule for the intelligent traceing to be captured
1.	*Open* "**Settings Classic**"
1.	*Open* "**Server-side Service monitoring**" menu group
1.	*Click* on "**Service naming rules**"
1.    For Rule name, *copy* and *paste*:
      ```
      Holistic API Rules
      ```
1.    For Service name format, *copy* and *paste*:
      ```
      {ProcessGroup:DetectedName}
      ```
1.    For Conditions name format, *select* **Detected process group name** from the dropdown
1.    Change matcher to **exists**
1.    Click *Preview* then **Save changes**

### 1.3 OpenPipeline Pipeline Configuration

1. *Open* "**OpenPipeline**" 
1. *Click* on "**Business events**" menu group
1. *Click* on "**Pipelines**"
1. *Create* a **new pipeline**
1. *Rename* the pipeline:

      ```
      BizObs Template Pipeline
      ```

### 1.4 OpenPipeline Processing Rule Configuration

1.	*Access* the "**Processing**" tab
1.	From the processor dropdown menu, *Select* "**DQL**" 
1.	*Name* the new processor, *copy* and *paste*:

      ```
      JSON Parser
      ```

1.	For "**Matching condition**", leave set to **true**
1.	For "**DQL processor definition**", *copy* and *paste*:

      ```
      parse rqBody, "JSON:json"
      | fieldsFlatten json
      | parse json.additionalFields, "JSON:additionalFields"
      | fieldsFlatten json.additionalFields, prefix:"additionalfields."
      ```

1.    Add another processor
1.	From the processor dropdown menu, *Select* "**DQL**" 
1.	*Name* the new processor, *copy* and *paste*:

      ```
      Error Field
      ```

1.	For "**Matching condition**", leave set to **true**
1.	For "**DQL processor definition**", *copy* and *paste*:

      ```
      fieldsAdd  event.type = if(json.hasError == true, concat(event.type, ``, " - Exception"), else:{`event.type`})
      ```

**At the top right of the screen, click "*Save*"**


### 1.5 OpenPipeline Dynamic Routing

1. *Access* the "**Dynamic routing**" tab
1. *Create* a *new Dynamic route*
1. For "**Name**", *copy* and *paste*: 

      ```
      BizObs App
      ```

1. For "**Matching condition**", *copy* and *paste*:

      ```
      isNotNull(event.provider)
      ```

1. For "**Pipeline**", *select* "**BizObs Template Pipeline**"
1. *Click* "**Add**" 

**Just above the table, click "*Save*"**
**Make sure you change Status to enable the Dynamic Routing**

*RUN SOME MORE TEST SIMULATIONS THROUGH YOUR BIZOBS APPLICATION UI**

### 1.6 Queries

##### Validate new attribute
1.	From the menu, *open* "**Notebooks**"
1.	*Click* on the "**+**" to add a new section
1.	*Click* on "**DQL**"
1.	*Copy* and *paste* the **query**:

      ```
      Fetch Bizevents
      | filter isNotNull(rsBody) and isNotNull(rqBody)
      | filter isNotNull(json.additionalFields) and isNotNull(json.stepIndex)
      | filter json.companyName == $Company
      | summarize count(), by:{event.type,json.stepName, json.stepIndex}
      | sort json.stepIndex asc
      ```
Run the simulations as many times as need to get all 12 events. Each svent will have a correlating "** - Exception**" event

