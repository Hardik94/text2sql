

c = get_config()
c.InteractiveShellApp.exec_lines = [
    "%load_ext jupyter_ai"
    "%load_ext sql",
    "%config SqlMagic.autocommit=False",
    f"%sql clickhouse://default:@chdb.default:8123/default"
]

c.InteractiveShellApp.extensions = [
    'sql'
]
# "%sql clickhouse://default:@10.18.0.42:18123/jen_ripsb"
# "%sql clickhouse://default:@chdb.default:8123/default"
