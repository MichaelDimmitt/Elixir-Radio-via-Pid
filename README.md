## Elixir-Radio-via-Pid


## Current Project Structure:

self() process is the radio it receives info. 

station() processes are radio stations that always send info.

## Alternate Project Structure:

self() process is the god_process or power_grid process director_of_the_play_process developer_process:
1) it turns the power on for the radio and it turns the power on for the radio stations.
2) it tunes the radio to a specific station after the radio defaults to 

station() processes are radio stations that always stream and send info to tuned radios.
<br/>radio() located inside a car can be tuned by a user or by a god_process.

