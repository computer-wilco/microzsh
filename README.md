# MicroZsh

A lightweight alternative to Oh My Zsh, improving load times while still keeping essential features like themes and plugins.

## Installation

Install MicroZsh by executing this script:

```sh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/computer-wilco/microzsh/master/tools/install.sh)"
```
This should generate a `.microzsh` directory and the default `.zshrc` in your home directory.

Continue by downloading and installing a theme, seen below.

## Configuring

MicroZsh comes with no default themes or plugins, so you need to download themes and plugins yourself.

The default directory is `$HOME/.microzsh/themes` and `$HOME/.microzsh/plugins`. If MicroZsh is loaded, you can also use `$THEMES` and `$PLUGINS`.

Themes should be a `.zsh-theme` file, plugins a directory with a file like `name.plugin.zsh`.

After placing the theme or plugin in the right directory, open your `.zshrc` in your home directory with your favorite text editor.

This should look something like this:

```sh
# If you move the directory to another location, 
# make sure to fill that corresponding 
# directory in here.
export ZSH="$HOME/.microzsh"

# Fill in the name of your installed theme here
ZSH_THEME=""

# Here you can write a list of plugins
# Do NOT separate the entries with a comma, this 
# WILL break everything
plugins=()

source $ZSH/microzsh.zsh
```

When done, it should look something like this:

```sh
export ZSH="$HOME/.microzsh"

ZSH_THEME="wilco"

plugins=(git autosuggestions syntax-highlighting)

source $ZSH/microzsh.zsh
```

The comments can be safely removed if you want, like above.

## Contributing

Contributions are always welcome!

If you want to contribute, you can open a issue or pull request on the [Github Repo](https://github.com/computer-wilco/microzsh).

## License

[MIT](https://choosealicense.com/licenses/mit/)
