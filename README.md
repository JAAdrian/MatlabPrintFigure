# PrintFigure
### A Class for Easy and Reproducible Figure Formatting And Printing in MATLAB

This class deals with the user's constant problem, to save pretty figures to disk in order to use them in a paper or a presentation. Therefore, the user can create a *json* file (which is called **profile** in this context) in which the desired layout values for the figure are set. **Using these profiles ensures reproducible...**


## Calling the Class

The object is created by calling

```matlab
obj = PrintFigure(FigureHandle);
obj = PrintFigure();
```

where `FigureHandle` denotes the handle to the figure which is to be formatted and printed.  
You can omit the argument which triggers the class to use the current figure (by using `gcf` internally).

## Content of a Layout Profile

```json
{
    "AxesFontSize":         10,
    "AxesFontName":         "Times",
    "AxisLineWidth":        0.75,
    "XColor":               [0.3,0.3,0.3],
    "YColor":               [0.3,0.3,0.3],
    "TickLength":           [0.02,0.02],
    "TickDir":              "out",
    "Box":                  "off",
    "XGrid":                "off",
    "YGrid":                "on",
    "PlotLineWidth":        1,
    "MarkerSize":           8,
    "LabelFontName":        "Times",
    "LabelFontSize":        14,
    "Interpreter":          "tex",
    "TickLabelInterpreter": "tex",
    "PaperPosition":        [0,0,21,13],
    "LegendEdgeColor":      [0.3,0.3,0.3]
}
```

## Applying a Layout Profile

```matlab
obj.Profile = 'paper';        % this is the default
obj.Profile = 'presentation';
obj.Profile = 'myprofile';
...
obj.Profile = 'help';
obj.Profile = [];
```

**json parser von basti**

## Changing the File Format for Printing

```matlab
obj.Format = 'pdf';   % this is the default
obj.Format = 'epsc';
obj.Format = 'png';
...
obj.Format = 'help';
obj.Format = [];
```

**Trigger help, supported formats**  
Typically, when printing figures to disk while using the `'pdf'` format, MATLAB prints a blank DIN A4 page and places the figure somewhere on it. This behaviour is fixed in this implementation.

## Changing the Resolution when Printing Bitmap Graphics

```matlab
obj.Resolution = 200; % this is the default
```

in dpi.

## Applying the Recently Introduced Parula Colormap

```matlab
obj.applyParulaMap;
```

## Printing the Figure to Disk

```matlab
obj.print(filename);
obj.print(filename,'nofix');
```

When the file format is one of `{'eps','epsc','eps2','epsc2'}` the created vector graphic is enhanced with the [fixPSlinestyle](http://www.mathworks.com/matlabcentral/fileexchange/17928-fixpslinestyle) function per default. **What does it do?** If this is not intended it can be turned off by passing `'nofix'` as second argument.

## Closing the Figure

```matlab
obj.close;
```


### Releasing the Figure

```matlab
obj.release;
```

### Locking the Figure

```matlab
obj.lock;
```
