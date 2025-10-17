## Lab 1: basic configuration and exploration 

This lab will show you how to *create* and *validate* **business rules**. 

### 1.1 OneAgent rule Configuration

##### Configure
1.	*Open* "**Settings Classic**"
1.	*Open* "**Business Analytics**" menu group
1.	*Click* on "**OneAgent**"
1.	*Click* on "**Add new capture rule**"
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

1.	For "**Event provider data source**", *select* "**Request - Body**"
1.	For "**Event provider fixed value**", *copy* and *paste*:
      ```
      data.companyName
      ```

##### Configure metadata (type)

1.	For "**Event type data source**", *select* "**Request - Body**"
1.	For "**Event type fixed value**", *copy* and *paste*:
      ```
      data.stepName
      ```

##### Configure additional data (rqBody)

1.	*Click* on "**Add data field**"
1.	For "**Data source**", make sure that "**Request - Body**" is *selected*
1.	For "**Field name**" and "**Path**", *copy* and *paste*:
      ```
      *
      ```

#### Configure additional data (rsBody) 

1. *Click* on "**Add data field**" 
1. For "**Data source**", make sure that "**Request - Body**" is *selected* 
1. For "**Field name**" and "**Path**", *copy* and *paste*: 
      ```
      *
      ```

**At the bottom of the screen, click "Save changes"**

### 1.2 Notebook

1.	*Open* "**Notebooks**"
1.	*Create* a **new notebook**
1.	*Click* on the "**+**" to add a **new section**
1.	*Click* on "**DQL**"
1.	Copy and *paste* the *query*:

      ```
      fetch bizevents
      | sort timestamp desc
      | filter isNotNull(rqBody) or isNotNull(rsBody)
      ```

### 1.3 OpenPipeline Pipeline Configuration

1.In your tenant Press CTRL+K
1. *Open* "**OpenPipeline**" under Settings
1. *Click* on "**Business events**"
1. *Click* on "**Pipelines**"
1. *Create* a **new pipeline**
1. *Rename* the pipeline:

      ```
      BizObs Pipeline
      ```

### 1.4 OpenPipeline Processing Rule Configuration

1.	*Access* the "**Processing**" tab
1.    We're going to add 2 processing rules
1.	From the processor dropdown menu, *Select* "**DQL**" 
1.	*Name* the first processor, *copy* and *paste*:

      ```
      JSON Parser
      ```

1.    For "**Matching condition**", leave set to **true**
1.	For "**DQL processor definition**", *copy* and *paste*:

      ```
      parse rqBody, "JSON:data"
      | fieldsFlatten data
      ```
1.	*Name* the second processor, *copy* and *paste*:

      ```
      Error Field
      ```

1.    For "**Matching condition**", *copt* and *paste*:

      ```
      matchesPhrase(rqBody, "hasError\":true")
      ```
      
1.	For "**DQL processor definition**", *copy* and *paste*:

      ```
      parse rqBody, "JSON:data"
      | fieldsAdd event.type = if(data.hasError == true, concat(event.type, ``, " - Exception"), else:{`event.type`})
      ```


**At the top right of the screen, click "*Save*"**

### 1.5 OpenPipeline Metric Extraction Configuration

### 1.6 OpenPipeline Dynamic Routing

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

1. For "**Pipeline**", *select* "**Asset purchase**"
1. *Click* "**Add**" 

**Just above the table, click "*Save*"**

### 1.8 Queries

##### Validate new attribute
1.	From the menu, *open* "**Notebooks**"
1.	*Click* on the "**+**" to add a new section
1.	*Click* on "**DQL**"
1.	*Copy* and *paste* the **query**:

      ```
      fetch bizevents
      | sort timestamp desc
      | filter isNotNull(rqBody) or isNotNull(rsBody)
      | filter isNotNull(data.companyName)
      ```
