## Lab 4: getting value from automation

In this hands-on, we’ll be setting up this process using some existing building blocks! You will have access to your own **Mattermost channel**, so you will be able to monitor that your messages [...]

### 4.1 Choosing when your Workflow will run
1. Using the “**App drawer**” in the top-left of the screen (or the search) – *find* the **“Workflow”** app and *open* it.
1. *Choose* “**+ Workflow**” in the top-right and you should see the view shown on the screen.
1. The first thing to do is *choose* **when this Workflow will run** – for the purpose of this exercise we will *choose* the “**On demand**” trigger at the bottom, so it will *only* be execut[...]

### 4.2 Querying the failed Order IDs
Now that we’ve set when this will run, we can start to add in the rest of the logic!

1. *Click* the purple “**+**” icon underneath your trigger and you’ll be presented with the options you see on the screen to add new logical “**tasks.**”
1. First **“task”** will be to get the **Company** and **StepNames** with issues – so we’ll *choose* the “Execute DQL Query” action which is going to look through the data for these us[...]
1. The DQL query itself will look through the data for the “**Exception**” events that get created – it will then return the contextual information that let’s us take some action, for exam[...] 

```
fetch bizevents, from:now()-24h
| filter matchesPhrase(event.type, "Exception")
| fields json.companyName, json.stepName, json.correlationId, json.errorType, json.errorMessage
```

### 4.3 Formatting the data to send

Our previous step will return the **“raw” data** of the errors that users are facing, but because we want to send this in a **Mattermost channel** – we’ll apply some formatting to make it [...]

1. Use the purple “**+**” again to *add* another “**task**” and this time *choose* “**Run Javascript**.”
1. *Copy* over the **JavaScript** from the lab guide into the “**input**” section that’s opened up on the **right-hand side**. 

```JavaScript
// optional import of sdk modules 
import { execution } from '@dynatrace-sdk/automation-utils'; 

export default async function ({ execution_id }) { 
  const yourName = "HAL9000";
  const dqlStepName = "execute_dql_query_1"; 

  // Fetch DQL result
  const r = await fetch(`/platform/automation/v1/executions/${execution_id}/tasks/${dqlStepName}/result`); 
  const body = await r.json(); 
  const events = body["records"]; 

  // Build Mattermost message
  let niceOutput = `:rotating_light: **[${yourName}] Exception Events Detected (Last 24h)** :rotating_light:\n`;

  events.forEach((event, index) => {
    niceOutput += `\n---\n:hash: **Event #${index + 1}**\n`
                + ` **Company**: \`${event['json.companyName']}\`\n`
                + `:gear: **Step**: \`${event['json.stepName']}\`\n`
                + `:link: **Correlation ID**: \`${event['json.correlationId']}\`\n`
                + `:boom: **Error Type**: \`${event['json.errorType']}\`\n`
                + `:speech_balloon: **Message**: _${event['json.errorMessage']}_\n`;
  });

  return niceOutput;
}
```

3. Near the top is a section titled “**Enter your details here!**” which has 2 values.
     - Enter “**your name**”. (either your actual name or something slightly humorous) *This will be used at the start of the message we send to Mattermost – in a real scenario, this could b[...]
     - *Enter* name of the “**task**” (or step) of the DQL we just added.  *If you didn’t change the name of that step leave it as-is, otherwise change it to the name that you have used.*

At a high-level what this **code** is *doing* is firstly *getting* the **results** of the **DQL** from the previous step, then creating a **nicely formatted message for Mattermost** where each Ord[...] 

### 4.4 Sending the orders to a Mattermost channel

The last step now is to *send* the **message** we’ve just created into the Mattermost channel. To make this possible we first need to create a “**URL**” that we can *send* the **messages** t[...] 

1. Open up the **ACE-box dashboard** and *select* the “**Links**” tab – there is a “**Mattermost**” row here and this will give you the URL and **credentials** to be able to *login*.
2. Once you’ve logged in, *click* the **icon** with four square in the **top-left** of the interface and choose **Integrations** > **Incoming Webhooks**. 
3. *Choose* to “**Add Incoming Webhook**” a new webhook, and *give* it a **title** 
4. *Set* the channel to “**Town Square**”
5. *Hit* “**Save**,” and make a *copy* of the **URL** that it provides.
6. In Dynatrace, head to the "**Settings Classic**" app and navigate to "**Preferences**" > "**Limit outbound connections.**"
7. Choose the option to "**Add item**" and add in the "**domain**" part of the URL from Mattermost.
8. - The end value should only have "mattermost.xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx.dynatrace.training"
8. Back in your Workflow, *Click* the purple “**+**” to add a new “**task**”
9. *Choose* the “**HTTP Request**" task
10. *Change* the request type to "**POST**"
11. For the "**URL**" box enter the URL that was just generated in Mattermost.
12. For the **payload** of the request, *enter* the **value below** so that it will send in the message we created in the JavaScript step:

```
{
  "text": "{{result("run_javascript_1") }}"
}
```
13. "**Save**" your progress at the top of the screen
14. Under “**Settings**” at the top, *enable* “**Workflow admin**.”

### 4.5 Run the Workflow
1. *Hit* the “**Run**” button at the top of the screen and your Workflow should run successfully! Keep an eye on the **Mattermost channel** for the “**name**” that you entered in the JavaS[...]