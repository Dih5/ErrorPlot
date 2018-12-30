# ErrorPlot

[![release v1.0.0](http://img.shields.io/badge/release-v1.0.0-brightgreen.svg)](https://github.com/dih5/ErrorPlot/releases/latest)
[![license MIT](https://img.shields.io/badge/license-MIT%20License-blue.svg)](https://github.com/dih5/ErrorPlot/blob/master/LICENSE.txt)
[![Mathematica 9-11](https://img.shields.io/badge/Mathematica-9--11-brightgreen.svg)](#compatibility)


An alternative to the ErrorBar Plotting Package included in Mathematica.
It allows for log-scale plotting and a freer syntax.

* [Features](#features)
* [Usage example](#usage-example)
* [Installation](#installation)
* [Documentation](#documentation)
* [Compatibility](#compatibility)
* [Contributing](#contributing)
* [License](#license)
* [Versioning](#versioning)

## Features
The package provides a family of functions `ErrorPlot`, `ErrorLogPlot`, `ErrorLogLinearPlot`, and `ErrorLogLogPlot` which extend the functionality of the ListPlot family to plot data with error bars.
## Usage example

A brief overview:

![alt tag](https://raw.github.com/dih5/ErrorPlot/master/demo.png)

This simple example is easy to generalize as if working with ListPlot. Some new options also allow for customizing the error bars' graphic style.

## Installation

There are various installation methods available.

### Automatic installation

To install the ErrorPlot package evaluate:
```Mathematica
Get["https://raw.githubusercontent.com/dih5/ErrorPlot/master/BootstrapInstall.m"]
```

This method uses [MathematicaBootstrapInstaller](https://github.com/jkuczm/MathematicaBootstrapInstaller) and will also install the
[ProjectInstaller](https://github.com/lshifr/ProjectInstaller) package if you don't have it already installed.

To load the ErrorPlot package evaluate: ``Needs["ErrorPlot`"]``.


### Manual installation

1. Download latest released
   [ErrorPlot.zip](https://github.com/dih5/ErrorPlot/releases/download/v1.0.0/ErrorPlot.zip)
   file.

2. Extract downloaded `ErrorPlot.zip` to any directory which is on the Mathematica `$Path`,
   e.g. to install for the current user `FileNameJoin[{$UserBaseDirectory,"Applications"}]`,
   for all users `FileNameJoin[{$BaseDirectory,"Applications"}]`.

3. To load the package evaluate: ``Needs["ErrorPlot`"]``.


### No installation

To use package directly from the Web, without installation, evaluate:
```Mathematica
Get["https://raw.githubusercontent.com/dih5/ErrorPlot/master/ErrorPlot/ErrorPlot.m"]
```

Note that with this method of initialization
package documentation will not be available in Mathematica Documentation Center.


### Paclet server

The package is also available from this [Mathematica Paclet Server](https://paclets.github.io/PacletServer/). Check the automated installation instructions [here](https://paclets.github.io/PacletServer/errorplot.html#main-content).


## Documentation

This application comes with documentation integrated with the Mathematica Documentation Center.
After installation search for "ErrorPlot" in documentation center
or press `F1` key with cursor on name of any of symbols introduced by this application.




## Compatibility

The package has been tested with Mathematica versions from 9.0 to 11.3 on Windows and Linux.
It will probably work in Mathematica 6.0+, but it has not been tested. If you do so, please let me know.



## Contributing

If you find any bugs or have a feature request you may create an
[issue on GitHub](https://github.com/dih5/ErrorPlot/issues).

Feel free to fork and send pull requests, all contributions are welcome.



## License

This package is released under
[The MIT License](https://github.com/dih5/ErrorPlot/master/LICENSE).



## Versioning

Releases of this package will be numbered using
[Semantic Versioning guidelines](http://semver.org/).
