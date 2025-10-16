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
      Asset purchase
      ```

##### Configure Trigger

1.	*Click* on "**Add trigger**"
1.	For "**Data source**", *select* "**Request - Path**"
1.	For "**Operator**", *select* "**equals**"
1.	For "**Value**", *copy* and *paste*:
      ```
      /api/step1
      ```

##### Configure metadata (provider)

1.	For "**Event provider data source**", *select* "**Fixed value**"
1.	For "**Event provider fixed value**", *copy* and *paste*:
      ```
      online-website
      ```

##### Configure metadata (type)

1.	For "**Event type data source**", *select* "**Fixed value**"
1.	For "**Event type fixed value**", *copy* and *paste*:
      ```
      asset-purchase
      ```

##### Configure additional data (price)

1.	*Click* on "**Add data field**"
1.	For "**Data source**", make sure that "**Request - Body**" is *selected*
1.	For "**Field name**" and "**Path**", *copy* and *paste*:
      ```
      price
      ```

#### Configure additional data (amount) 

1. *Click* on "**Add data field**" 
1. For "**Data source**", make sure that "**Request - Body**" is *selected* 
1. For "**Field name**" and "**Path**", *copy* and *paste*: 
      ```
      amount
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
      | filter event.type=="asset-purchase"
      ```

### 1.3 OpenPipeline Pipeline Configuration

1. *Open* "**OpenPipeline**" 
1. *Click* on "**Business events**" menu group
1. *Click* on "**Pipelines**"
1. *Create* a **new pipeline**
1. *Rename* the pipeline:

      ```
      Asset purchase
      ```

### 1.4 OpenPipeline Processing Rule Configuration

1.	*Access* the "**Processing**" tab
1.	From the processor dropdown menu, *Select* "**DQL**" 
1.	*Name* the new processor, *copy* and *paste*:

      ```
      Calculate revenue
      ```

1.	For "**Matching condition**", leave set to **true**
1.	For "**DQL processor definition**", *copy* and *paste*:

      ```
      fieldsAdd trading_volume = price*amount
      ```

**At the top right of the screen, click "*Save*"**

### 1.5 OpenPipeline Metric Extraction Configuration


1.	*Open* the "**Asset purchase**" pipeline again
1.	*Access* the "**Metric extraction**" tab
1.	*Create* a "**new processor**" that's a "**Value metric**"
1.	For "**Name**", *copy* and *paste*:

      ```
      Calculate revenue
      ```

1.	For "**Matching condition**", *leave* as **true**
1.	In "**Field extraction**", *copy* and *paste*:

      ```
      step_completion
      ```

1. For "**Metric key**", *copy* and *paste*:

      ```
      bizobs.step_completion
      ```

**At the top right of the screen, click "*Save*"**

### 1.6 OpenPipeline Bucket Assignment Rule Configuration

1.	*Open* the "**Asset purchase**" pipeline again
1.	*Click* on "**Storage**"
1.	*Create* a new processor in "**Bucket assignment**"
1.	For "**Name**", *copy* and *paste*:
      ```
      Asset Purchase
      ```
1. For "**Matcher**", leave set to "**true**"
1. For "**Storage**", *Select* "**Business Events**"

**At the top right of the screen, click "*Save*"**

### 1.7 OpenPipeline Dynamic Routing

1. *Access* the "**Dynamic routing**" tab
1. *Create* a *new Dynamic route*
1. For "**Name**", *copy* and *paste*: 

      ```
      Asset Purchase
      ```

1. For "**Matching condition**", *copy* and *paste*:

      ```
      event.type=="asset-purchase"
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
      | filter event.type == "asset-purchase"
      | filter isNotNull(trading_volume)
      | fields price, amount, trading_volume
      ```

##### Validate metric

1.	*Click* on the "**+**" to add a new section
1.	*Click* on "**DQL**"
1.	*Copy* and *paste* the **query**:

      ```
      timeseries avg(bizobs.step_completion)
      ```

1.	*Click* on "**Run query**"
1.	*Wait* for the **first data points** to appear
