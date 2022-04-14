global function IdleMapChangeInit

float idleWaitTime;
float idleWaitInterval;
bool isIdle = true;

void function IdleMapChangeInit()
{
	AddCallback_OnClientConnected(IdleMapChange_ClientConnected);
	AddCallback_OnClientDisconnected(IdleMapChange_ClientDisconnected);

	idleWaitTime = GetConVarFloat("idle_map_change_time");
	idleWaitInterval = GetConVarFloat("idle_map_change_interval");
	thread IdleMapChangeTimer();
}


void function IdleMapChangeTimer()
{
	while (isIdle) {
		if (Time() > idleWaitTime) {
			isIdle = false;
			PostmatchMap();
		}
		else {
			printl(format("Idle on %s %s - %i:%i until map change", GetMapName(), GameRules_GetGameMode(), (idleWaitTime - Time())/60, (idleWaitTime - Time())%60));
		}

		wait idleWaitInterval;
	}
}

void function IdleMapChange_ClientConnected(entity player) {
	isIdle = false;
}

void function IdleMapChange_ClientDisconnected(entity player) {
	// Start the timer again if there are no more players
	if (GetPlayerArray().len() - 1 <= 0) {
		isIdle = true;
		idleWaitTime += Time(); // Reset timer
		thread IdleMapChangeTimer();
	}
}
