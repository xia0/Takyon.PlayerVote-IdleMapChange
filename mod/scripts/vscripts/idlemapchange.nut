global function IdleMapChangeInit

float idleWaitTime;
bool isIdle = true;

void function IdleMapChangeInit()
{
	AddCallback_OnClientConnected(IdleMapChange_ClientConnected)
	AddCallback_OnClientDisconnected(IdleMapChange_ClientDisconnected)

	idleWaitTime = float(GetConVarInt( "idle_map_change_time" ))
	thread IdleMapChangeTimer();
}


void function IdleMapChangeTimer()
{
	while (isIdle)
	{
		if (Time() > idleWaitTime) {
			isIdle = false;
			if (GetPlayerArray().len() == 0) PostmatchMap();
		}
		printl(GetMapName() + " " + GameRules_GetGameMode() + " " + (idleWaitTime - Time()) + " seconds until map change");
		wait 1;
	}
}

void function IdleMapChange_ClientConnected(entity player) {
	isIdle = false;
}

void function IdleMapChange_ClientDisconnected(entity player) {
	if (GetPlayerArray().len() - 1 <= 0) {
		isIdle = true;
		idleWaitTime += Time(); // Reset timer
		thread IdleMapChangeTimer();
	}
}
