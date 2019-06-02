-- Start a transaction.
BEGIN;

-- Plan the tests.
SELECT tap.plan(23);

SELECT tap.has_table(database(), 'rpt_sorties_over_time', 'table rpt_sorties_over_time exists');
SELECT tap.has_table(database(), 'rpt_player_online_activity', 'table rpt_player_online_activity exists');
SELECT tap.has_table(database(), 'custom_menu_item', 'table custom_menu_item exists');
SELECT tap.has_table(database(), 'meta', 'table meta exists');
SELECT tap.has_table(database(), 'map', 'table map exists');

SELECT tap.hasnt_table(database(), 'xref_game_map_server', 'table xref_game_map_server dropped');
SELECT tap.hasnt_table(database(), 'map_layer', 'table map_layer dropped');
SELECT tap.hasnt_table(database(), 'game_map', 'table game_map dropped');
SELECT tap.hasnt_table(database(), 'capture_point', 'table capture_point dropped');
SELECT tap.hasnt_table(database(), 'depot', 'table depot dropped');
SELECT tap.hasnt_table(database(), 'side_mission', 'table side_mission dropped');
SELECT tap.hasnt_table(database(), 'depot', 'table depot dropped');

SELECT tap.has_column(database(), 'raw_connection_log', 'time', 'column time exists in table raw_connection_log');
SELECT tap.has_column(database(), 'backup_connection_log', 'time', 'column time exists in table backup_connection_log');

SELECT tap.has_column(database(), 'server', 'description', 'column description exists in table server');
SELECT tap.has_column(database(), 'server', 'simple_radio_enabled', 'column simple_radio_enabled exists in table server');
SELECT tap.has_column(database(), 'server', 'simple_radio_ip_address', 'column simple_radio_ip_address exists in table server');
SELECT tap.has_column(database(), 'server', 'map_id', 'column map_id exists in table server');

SELECT tap.has_column(database(), 'raw_gameevents_log', 'date', 'column date exists in table raw_gameevents_log');
SELECT tap.has_column(database(), 'backup_gameevents_log', 'date', 'column date exists in table backup_gameevents_log');

SELECT tap.has_column(database(), 'rpt_airframe_sortie', 'hits_received', 'column hits_received exists in table rpt_airframe_sortie');

SELECT tap.has_trigger(database(), 'raw_connection_log', 'trg_raw_connection_log_current_time', 'trigger trg_raw_connection_log_current_time exists');
SELECT tap.has_trigger(database(), 'raw_gameevents_log', 'trg_raw_gameevents_log_current_time', 'trigger trg_raw_gameevents_log_current_time exists');


-- Finish the tests and clean up.
CALL tap.finish();
ROLLBACK;