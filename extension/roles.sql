
/* User */
GRANT ALL ON SCHEMA qwat_raepa TO qwat_user;
GRANT ALL ON ALL TABLES IN SCHEMA qwat_raepa TO qwat_user;
ALTER DEFAULT PRIVILEGES IN SCHEMA qwat_raepa GRANT ALL ON TABLES TO qwat_user;

/* Viewer */
GRANT ALL ON SCHEMA qwat_raepa TO qwat_viewer;
GRANT ALL ON ALL TABLES IN SCHEMA qwat_raepa TO qwat_viewer;
ALTER DEFAULT PRIVILEGES IN SCHEMA qwat_raepa GRANT ALL ON TABLES TO qwat_viewer;


/* Manager */
GRANT ALL ON SCHEMA qwat_raepa TO qwat_manager;
GRANT ALL ON ALL TABLES IN SCHEMA qwat_raepa TO qwat_manager;
ALTER DEFAULT PRIVILEGES IN SCHEMA qwat_raepa GRANT ALL ON TABLES TO qwat_manager;

/* SysAdmin */
GRANT ALL ON SCHEMA qwat_raepa TO qwat_sysadmin;
GRANT ALL ON ALL TABLES IN SCHEMA qwat_raepa TO qwat_sysadmin;
ALTER DEFAULT PRIVILEGES IN SCHEMA qwat_raepa GRANT ALL ON TABLES TO qwat_sysadmin;
