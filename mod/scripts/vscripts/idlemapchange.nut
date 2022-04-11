global function IdleMapChangeInit

float idleWaitTime;
bool isIdle = true;

void function IdleMapChangeInit()
{
	AddCallback_OnClientConnected(IdleMapChange_ClientConnected);
	AddCallback_OnClientDisconnected(IdleMapChange_ClientDisconnected);

	idleWaitTime = float(GetConVarInt("idle_map_change_time"));
	idleWaitInterval = float(GetConVarInt("idle_map_change_interval"));
	thread IdleMapChangeTimer();
}


void function IdleMapChangeTimer()
{
	while (isIdle) {
		if (Time() > idleWaitTime) {
			isIdle = false;
			PostmatchMap();
		}
		printl(GetMapName() + " " + GameRules_GetGameMode() + " " + (idleWaitTime - Time()) + " seconds until map change");
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
