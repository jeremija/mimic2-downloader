# MIMIC2-Downloader

These scripts provide a way of downloading mimic2 datasets from
[here][1] and importing them to a PostgreSQL database.

It works similar to MIMIC-Importer-2.6, however I've had some problems with
it so I wrote my own script.

# Usage

1. Make sure you have access to the MIMICII dataset. You can obtain access
[here][2].
1. Make sure PostgreSQL is installed, and you're running Linux
2. Make sure your user has access to PostgreSQL and has superuser rights
3. Clone the repository and cd into it
4. Run `./download.sh` to download all files
5. Run `./import.sh` to import all files

To prevent asking for username/password, the following environment variables
can be set:

- `DL_USER`
- `DL_PASS`

# License

MIT

[1]: https://physionet.org/works/MIMICIIClinicalDatabase/files/
[2]: https://physionet.org/works/MIMICIIClinicalDatabase/access.shtml
