# PrintFigure
### A Class for Easy and Reproducible Figure Formatting And Printing in MATLAB

This class deals with the user's constant problem, to save pretty figures to disk in order to use them in a paper or a presentation. Therefore, the user can create a [json file](https://en.wikipedia.org/wiki/JSON) (which is called **profile** in this context) in which the desired layout values for the figure are set. Using these profiles ensures easy reproducible printing for a given figure.


## Calling the Class

The object is created by calling

```matlab
obj = PrintFigure(FigureHandle);
obj = PrintFigure();
```

where `FigureHandle` denotes the handle to the figure which is to be formatted and printed.  
You can omit the argument which triggers the class to use the current figure (by using `gcf` internally).

## Content of a Layout Profile

The current content of the default profile is listed below.

As can be seen, the json file consists of a main object which contains a number of sub objects which define the kind of handle to which the containing key/value pair should be applied to. For instance, if the font size of the figure axes should be set to 10pt, the key "FontSize" needs to be in the `axes` object. The key names and the corresponding values **have to match** the respective handle properties and their values. This way, an arbitrary set of key/value pairs can be included in a profile and applied by the `PrintFigure` object.

Each sub object's name is mandatory at the moment, ie. *axes, line, figure, label, legend* cannot be named differently. However, the json file does not need to contain all sub objects.

Content of `default.json`:
```json
{
    "axes": {
        "FontSize":             10,
        "FontName":             "Times",
        "LineWidth":            0.75,
        "TickLength":           [0.02,0.02],
        "TickDir":              "out",
        "Box":                  "off",
        "XGrid":                "off",
        "YGrid":                "on",
        "TickLabelInterpreter": "tex",
        "XColor":               [0.3,0.3,0.3],
        "YColor":               [0.3,0.3,0.3]
    },
    
    "line": {
        "LineWidth":  1,
        "MarkerSize": 8
    },
    
    "figure": {
        "PaperPosition": [0,0,21,13]
    },
    
    "label": {
        "FontName":    "Times",
        "FontSize":    14,
        "Interpreter": "tex"
    },
    
    "legend": {
        "EdgeColor":   [0.3,0.3,0.3],
        "Interpreter": "tex",
        "FontSize":    14
    }
}
```
Note that the standard figure position units are **centimeters** and are fixed at the moment!


## Applying a Layout Profile

Setting the `Profile` property of the object defines the used profile for formatting and subsequent printing where the profile string is the filename of the profile *json* file without file extension. The profile files are located in the *profiles* folder in the class directory.

```matlab
obj.Profile = 'default';
% obj.Profile = 'paper';
% obj.Profile = 'presentation';
% obj.Profile = 'mycustomprofile';
% ...
```

Tab completion is enabled while selecting an available profile by pressing `<Tab>` after typing the first quote. For example

```matlab
obj.Profile = '<Tab>
```

to get a list of all available profiles in the profile folder.
 

The `PrintFigure` class uses `parsejson.m` by [bastibe](https://github.com/bastibe/transplant) which is part of a Python bridge to MATLAB.

## Changing the File Format for Printing

To define the file format for printing the figure set the `Format` property of the object by

```matlab
obj.Format = 'pdf';   % this is the default
% obj.Format = 'epsc';
% obj.Format = 'png';
% ...
```

Tab completion is enabled while selecting an available format by pressing `<Tab>` after typing the first quote. For example

```matlab
obj.Format = '<Tab>
```

to get a list of all available formats for printing.

Usually, when printing figures to disk while using the `'pdf'` format, MATLAB prints a blank DIN A4 page and places the figure somewhere on the page. This behavior is fixed in this implementation.

## Changing the Resolution when Printing Pixel Graphics

When a pixel graphic file format like `png` is desired the pixel resolution can be defined by setting the `Resolution` property of the object by

```matlab
obj.Resolution = 200; % this is the default
```

in dots per inch (dpi). This property has no clear effect if a vector graphic format is used.

## Applying the Recently Introduced Parula or Viridis Colormap

In MATLAB versions less than R2014b the old and ugly colormap is used per default. To change the colormap to the recently introduced *Parula* map you can call the following method:

```matlab
obj.parula;
```

If the new default `matplotlib` colormap *viridis* is desired use

```matlab
obj.viridis;
```

## Printing the Figure to Disk

The actual printing is done by calling the `print` method of the object and passing a string with the desired filename without the file extension.

```matlab
obj.print(filename);
obj.print(filename,'nofix');
```

When the file format is one of `{'eps','epsc','eps2','epsc2'}` the created vector graphic's appearance is enhanced with the [fixPSlinestyle](http://www.mathworks.com/matlabcentral/fileexchange/17928-fixpslinestyle) function by default. In older MATLAB releases the applied linestyle in the eps file had bug resulting not appealing dash-dotted or dotted lines if used in the figure. If this is not intended it can be disabled by passing `'nofix'` as second argument.

## Saving the Object incl. Print Data to Disk

A feature of the class is to save the MATLAB figure and the current state of the object in one `mat` file to disk. This is useful if the figure shall be altered later on or be used in a presentation. Additionally, all data of the plot is included in the figure which will be saved. This can be beneficial if a reproducible publication is planned using the saved plots.

```matlab
obj.saveFigure(filename);
```

## Loading a Saved Figure Object

To load a saved figure object it is ordinarily loaded to the MATLAB workspace by

```matlab
load filename.mat; % this loads a 'FigObj' object per default
```

The class's method `loadFigure` will recreate the figure in its last state with all set properties.

```matlab
FigObj.loadFigure;
```

The figure is then manipulable with the object's properties and methods as shown above.

## Closing the Figure

By default, the figure is locked to prevent it from being closed by the user while manipulating the figure using the object. To close the figure while the object exists, the `close` method can be called

```matlab
obj.close;
```

or, alternatively, the object can be destroyed by

```matlab
delete(obj)
```

### Releasing the Figure

To release the figure lock without closing it, the `release` method can be called

```matlab
obj.releaseFigure;
```

### Locking the Figure

To lock the figure again, the `lock` method can be called

```matlab
obj.lockFigure;
```


# TODO Notes

- [x] improve the handling of new properties
- [ ] improve documentation (comments and help for each function). Ongoing effort...
- [ ] let the PaperUnits be selectable in the profile. The convention at the moment is centimeters
 
