## slack user
* Has many channel stats
* Has many slack channels through channel stats

```
slack_identifier
handle
real_name
profile_image
stats_id
```

## channel stats
```
slack_channel_id
slack_user_id
messages_given
reactions_given
```

## slack channels
```
slack_identifier
name
```

# events to keep local cache updated
```
channel created
channel rename
user change
```


## scored events to subscribe to:
```
reaction_added (+1)
reaction_removed (-1)
public messages (+1)
delete_message (-1)
```




## example event
```
{
  "token": "z26uFbvR1xHJEdHE1OQiO6t8",
    "team_id": "T061EG9RZ",
    "api_app_id": "A0FFV41KK",
    "event": {
      "type": "reaction_added",
      "user": "U061F1EUR",
      "item": {
        "type": "message",
        "channel": "C061EG9SL",
        "ts": "1464196127.000002"
      },
      "reaction": "slightly_smiling_face",
      "item_user": "U0M4RL1NY"
        "event_ts": "1465244570.336841"
    },
    "type": "event_callback",
    "authed_users": [
      "U061F7AUR"
    ],
    "event_id": "Ev9UQ52YNA",
    "event_time": 1234567890
}
```
