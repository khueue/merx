# Merx: Simple One-Off File Transfer

Give Merx a file path and it will start a temporary server, serving that
single file to a single connection a single time.

## Usage

Merx can be run like this:

    $ merx /path/to/file.zip
    Merx is running and awaits a single connection (timeout [time] minutes).
    "http://[your-ip]:[some-port]/file.zip" copied to clipboard.

Paste the copied URL into your favorite messaging client and forget it.

## (Far) Future

### More Arguments

 * Port (range?)
 * Timeout (in minutes) (default 10)

### GUI

 * Drag and drop files into some widget
 * See current transfers and connections etc.

### Miscellaneous

 * Ability to tag IPs and ports making common transfers even simpler
