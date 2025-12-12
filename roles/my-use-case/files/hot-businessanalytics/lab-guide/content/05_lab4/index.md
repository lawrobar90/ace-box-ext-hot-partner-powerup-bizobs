## Lab 4: creating automation for security events

In this hands-on, we’ll be setting up this process using some existing building blocks! You will be capturing cheat logs, then using automation you will reduce the risk and increase revenue for your casino. 

### 4.1 Locking the users out
1. Using the “**App drawer**” in the top-left of the screen (or the search) – *find* the "**Workflows**" app and *open* it.
1. *Click* "**+ Workflow**"
1. In the first step, select "**On demand trigger**"
1. Click the *+* underneath the trigger step, and choose "**Execute DQL Query**"
1. Change the name of this step, *copy* and *paste*:
   ```
   get_cheaters
   ```
1. In the "**DQL query section**", *copy* and *paste*:
   ```
   fetch bizevents, from:now()-5m
      | filter json.cheat_active == true
      | filter isNotNull(json.winAmount)
      | fields timestamp,
             json.CustomerName, 
             json.cheatType,
             json.winAmount,
             json.Balance,
             json.CorrelationId,
             json.DetectionRisk,
             json.requires_investigation,
             json.BetAmount,
             json.multiplier,
             json.cheat_active,
             json.result, dt.openpipeline.pipelines
   ```
1. Click the *+* underneath the *get_cheaters* step, and choose "**HTTP Request**"
1. Change the name of this step, *copy* and *paste*:
   ```
   lock_user
   ```
1. In the "**Method**", Select *POST*
1. In the "**URL **", *copy* and *paste*:
   ```
   http://3.209.41.33:8080/api/admin/lockout-user-cheat
   ```
1. In the "**Payload**", *copy* and *paste*:
   ```
   {
        "cheatRecords": {{ result('get_cheaters').records }}
   }   
   ```
1. Click the *+* underneath the *lock_user* step, and choose "**Run JavaScript**"
1. Change the name of this step, *copy* and *paste*:
   ```
   create_bizevents_for_lockouts
   ```
1. In the "**Source code**", *copy* and *paste*:
   ```
   import { execution } from '@dynatrace-sdk/automation-utils';
      import { businessEventsClient } from '@dynatrace-sdk/client-classic-environment-v2';

      export default async function ({ execution_id }) {
        const stepName = "lock_user";

        // Fetch lock_user result
        const r = await fetch(`/platform/automation/v1/executions/${execution_id}/tasks/${stepName}/result`);
        const raw = await r.json();

        const lockResult = raw?.json ? raw.json : (typeof raw === "string" ? JSON.parse(raw) : raw);
        const results = lockResult?.results || [];

        if (!results.length) {
    return { success: false, events_created: 0, message: "No lock_user results found", raw_response: lockResult };
        }

        // Build Dynatrace business events (flat schema)
        const bizevents = results
          .filter(r => r.success)
          .map((r, i) => ({
            id: `vegas-lock-${r.username}-${Date.now()}-${i}`,
            "event.provider": "vegas-casino-fraud-detection",
            "event.type": "CheatReimbursed",
            user_locked: true,
            customer_name: r.username,
            cheat_violations: r.cheatViolations,
            winnings_confiscated: r.totalWinningsConfiscated,
            balance_before: r.balanceBefore,
            balance_after: r.balanceAfter,
            lock_reason: r.lockReason,
            detection_method: "lock_user_step_summary",
            timestamp: new Date().toISOString()
          }));

        // Log payload before sending
        console.log("Business events payload:", JSON.stringify(bizevents, null, 2));

        // Ingest into Dynatrace
        await businessEventsClient.ingest({
          type: "application/json",
          body: bizevents
        });

        return {
          success: true,
          events_created: bizevents.length,
          message: `Created ${bizevents.length} business events from ${results.length} lock_user results`,
          summary: lockResult?.summary || {}
        };
      }
      ```
1.   *Click* "**Depoloy**", and *Run* the workflow to test it works.
1.   You will see Customers who are cheating, but likely will not see your name yet.

### Go back to the "**Vegas App**" and play some games with cheats enabled

1. Go back to your notebook
1. Add a new DQL, *copy* and *paste*:
      ```
      fetch bizevents
      | filter event.type == "CheatFound"
      | fields timestamp,
             json.CustomerName, 
             json.cheatType,
             json.winAmount,
             json.Balance,
             json.CorrelationId,
             json.DetectionRisk,
             json.requires_investigation,
             json.BetAmount,
             json.multiplier,
             json.cheat_active
      ```
1.  When you see your *customer_name*, go back to the workflow you just created and "**Run**"
1. Go back to your notebook
1. Add a new DQL, *copy* and *paste*:
      ```
      fetch bizevents
      | filter event.provider == "vegas-casino-fraud-detection"
      | fields timestamp,
            cheat_violations,
            customer_name,
            winnings_confiscated,
            detection_method,
            balance_after,
            lock_reason,
            user_locked,
            event.type
      ```
