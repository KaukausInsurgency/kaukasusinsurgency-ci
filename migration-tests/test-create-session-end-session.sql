-- Start a transaction.
BEGIN;

-- Plan the tests.
SELECT tap.plan(9);

-- SETUP TEST FIXTURE
SET @ServerID := 1;
DELETE FROM online_players WHERE server_id = @ServerID;
INSERT INTO online_players (server_id, ucid, name, role, side, ping)
VALUES (@ServerID, 'AAA-BBB-CCC-DDD', 'TAP User', 'Test', 0, 0);

SELECT tap.ok(COUNT(*) > 0, 'Test data present in online_players table for test') 
	FROM online_players 
    WHERE server_id = @ServerID;
    
SELECT tap.eq('Offline', status, 'server status should be offline') 
	FROM server
    WHERE server_id = @ServerID;
-- END TEST FIXTURE SETUP

SET @SessionID:= ( CreateSession(@ServerID, 0, 0));

SELECT tap.ok(@SessionID > 0, 'CreateSession should return SessionID');
SELECT tap.ok(COUNT(*) = 0, 'online_players table should be empty after CreateSession') 
	FROM online_players 
    WHERE server_id = @ServerID;
SELECT tap.eq('Online', status, 'server status should be online after CreateSession')
	FROM server
    WHERE server_id = @ServerID;
    

INSERT INTO online_players (server_id, ucid, name, role, side, ping)
VALUES (@ServerID, 'AAA-BBB-CCC-DDD', 'TAP User', 'Test', 0, 0);

SELECT tap.ok(COUNT(*) > 0, 'Test data present in online_players table ater CreateSession') 
	FROM online_players 
    WHERE server_id = @ServerID;
    
SELECT tap.ok(EndSession(@ServerID, @SessionID, 1000, 1000, 'Offline') = 1, 'EndSession completed successfully');

SELECT tap.ok(COUNT(*) = 0, 'online_players table should be empty after EndSession') 
	FROM online_players 
    WHERE server_id = @ServerID;
SELECT tap.eq('Offline', status, 'server status should be offline after EndSession')
	FROM server
    WHERE server_id = @ServerID;   

-- Finish the tests and clean up.
CALL tap.finish();
ROLLBACK;