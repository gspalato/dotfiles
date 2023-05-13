#!/usr/bin/env python

# WALLpaper haNdling UTility
#
# A centralized way of setting a wallpaper with pywal,
# so other scripts can read it's config and know what's
# the current wallpaper, as well as the wallpaper directory.
#
# I created this to learn a bit of python, tbh.


import os, sys, random as randomgen
import argparse, configparser

default_folder = '/usr/share/backgrounds'
__location__ = os.path.realpath(
    os.path.join(os.getcwd(), os.path.dirname(__file__)))

# Predefined functions
def send_notification(title, body, icon, timeout=1500, uid="0111", urgency="normal"):
    cmd = f'dunstify -a "Wallnut" -i "{icon}" -t "{timeout}" -r "{uid}" -u "{urgency}" "{title}" "{body}"'
    os.popen(cmd)

def get_script_path():
    return os.path.dirname(os.path.realpath(sys.argv[0]))

def get_random_wallpaper(path):
    dirlist = os.listdir(os.path.expanduser(path))
    if (len(dirlist) == 0):
        print('Directory is empty. Aborting...')
        exit()

    return randomgen.choice(os.listdir(os.path.expanduser(path)))

def print_error(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)

def write_config(cfg):
    with open(os.path.join(__location__, 'config.ini'), 'w') as file:
        cfg.write(file)

def to_bool(v):
    if (isinstance(v, bool)):
        return v
    elif (isinstance(v, str)):
        return v.lower() in ("yes", "true", "t", "1")
    elif (isinstance(v, int)):
        return v > 0

# Load configuration file
config = configparser.ConfigParser()

try:
    config.read(os.path.join(__location__, 'config.ini'))
except (configparser.ParsingError):
    # If config.ini doesn't exist, create one.
    config.set('UserConfig', 'FolderPath', default_folder)
    config.set('UserConfig', 'Wallpaper', '')
    config.set('UserConfig', 'Random', False)
    config.set('Internal', 'Current', '')
    write_config(config)
    exit()


# Load user configurations.
folderpath = config.get('UserConfig', 'FolderPath', fallback=default_folder)
userwallpaper = config.get('UserConfig', 'Wallpaper', fallback='')
random = to_bool(config.get('UserConfig', 'Random', fallback=False))

is_user_wallpaper_set = len(userwallpaper) > 0

current = None

# Load internal configurations
if (os.path.isfile(userwallpaper)):
    config.set('Internal', 'Current', userwallpaper)
    current = userwallpaper

try:
    current = current or config.get('Internal', 'Current')
except (configparser.NoSectionError):
    config.set('Internal', 'Current', get_random_wallpaper(folderpath))

# Handle arguments
parser = argparse.ArgumentParser()

parser.add_argument('-r', '--random',
    help='select a random wallpaper',
    action='store_true',
    default=random
)

parser.add_argument('-f', '--folder',
    help='use path instead of the one at config.ini',
    type=str,
    default=folderpath
)

parser.add_argument('-c', '--current',
    help='get the current wallpaper path',
    action='store_true',
    default=False
)

args = parser.parse_args()

random = args.random
folderpath = os.path.expanduser(args.folder)

if (args.current):
    print(current)
    exit()

if (random):
    print('Getting random wallpaper.')
    current = get_random_wallpaper(folderpath)

if (not os.path.isdir(folderpath)):
    print_error('Supplied folder isn\'t valid.')
    exit()

current = os.path.expanduser(userwallpaper) if (is_user_wallpaper_set and not random) else os.path.join(folderpath, current)
config.set('Internal', 'Current', current)

# Apply with pywal
pywal_stream = os.popen(f'wal -i {current} --backend colorthief')
pywal_output = pywal_stream.read()

swww_stream = os.popen(f'swww img {current}')
swww_output = swww_stream.read()

# Create GTK theme with wpgtk
wpgtk_stream = os.popen(f'wpg -a {current} -s {current}')
wpgtk_output = wpgtk_stream.read()

# Handle gifs
#if (current.endswith('.gif')):
#    print("Applying GIF wallpaper.")
#    gApply = os.path.join(get_script_path(), 'gif')
#    os.popen('killall xwinwrap')
#    os.popen('killall gifview')
#    gStream = os.popen(f'{gApply} {current}')
#    gOutput = gStream.read()

write_config(config)

print(f'Applying {("random" if random else "")} wallpaper at {current}')
print(f'swww:\n{swww_output}')
print(f'pywal:\n{pywal_output}')
print(f'wpgtk:\n{wpgtk_output}')

send_notification("Applied wallpaper!", f"{os.path.basename(current)}", current)