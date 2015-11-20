BeginPackage["ErrorPlot`"]

ErrorPlot::usage="ErrorPlot[{pt1, pt2, ...}] plots the data of a List of points, optionally including error bars. Each point is a List of numerical values whose meaning is the defined by option DataFormat.
ErrorPlot[{list1, list2,...}] plots several data series";
ErrorLogPlot::usage="ErrorLogPlot[{pt1, pt2, ...}] makes a log plot of the data of a List of points, optionally including error bars. Each point is a List of numerical values whose meaning is the defined by option DataFormat.
ErrorLogPlot[{list1, list2,...}] plots several data series";
ErrorLogLinearPlot::usage="ErrorLogLinearPlot[{pt1, pt2, ...}] makes a log-linear plot of the data of a List of points, optionally including error bars. Each point is a List of numerical values whose meaning is the defined by option DataFormat.
ErrorLogLinearPlot[{list1, list2,...}] plots several data series";
ErrorLogLogPlot::usage="ErrorLogLogPlot[{pt1, pt2, ...}] makes a log-log plot of the data of a List of points, optionally including error bars. Each point is a List of numerical values whose meaning is the defined by option DataFormat.
ErrorLogLogPlot[{list1, list2,...}] plots several data series";

DataFormat::usage="DataFormat is an option for error-plotting that \
specifies the meaning of each data point coordinate."

PointMarkers::usage="PointMarkers is an option for error-plotting that \
specifies the marker used for the data points (and not the error-estimation points). This option is ignored if PlotMarkers is used."
ErrorBarTickStyle::usage="ErrorBarTickStyle is an option for error-plotting that \
specifies the style used for error bar ticks. This option is ignored if PlotMarkers is used."
ErrorBarTickSize::usage="ErrorBarTickSize is an option for error-plotting that \
specifies the size of error bar ticks. A 0 value means no ticks are used. This option is ignored if PlotMarkers is used."

VerticalBarStyle::usage="VerticalBarStyle is an option for error-plotting that \
specifies the style in which vertical error bars are plotted."
HorizontalBarStyle::usage="HorizontalBarStyle is an option for error-plotting that \
specifies the style in which horizontal error bars are plotted."
PlotErrorBars::usage="PlotErrorBars is an option for error-plotting that \
specifies whether markers and error bars (in each axis) are plotted."


Begin["`Private`"]
(* Note some private functions are intentionally described here *)
PatternMatchQ[pattern_, format_] :=
    Position[Map[StringMatchQ[#, pattern, IgnoreCase -> True] &, format],
      True]
PatternMatchQ::usage = 
  "PatternMatchQ[pattern,format] returns the list of positions in \
List Format in which pattern is met.";

FindPatterns[patternList_List, format_List] :=
    Module[ {t},
        t = Map[PatternMatchQ[#, format] &, patternList];
        If[ Apply[And, Map[# != {} &, t]],
            Flatten[Map[First, t]],
            {}
        ]
    ]
FindPatterns::usage = 
  "FindPatterns[patternList,format] returns a list with the first \
positions in which each pattern  of the List patternList is met. If \
ANY of this patterns is not met, it returns an empty List.";

FindGetter[rules_List, fGetter_List, format_] :=
    Module[ {t, i},
        For[i = 1, i <= Length[rules], i++,
             t = FindPatterns[rules[[i]], format];
             If[ t != {},
                 Break[]
             ];
         ];
        If[ i <= Length[rules],
            {fGetter[[i]], t},
            {Null &, {1}}
        ]
    ]
FindGetter::usage = 
  "FindGetter[rules_List,fGetter_List,format_] tries to find a \
suitable Getter for data with given format. A Getter (nothing to do with OOP's getters) is a pair of a \
Function and a List of positions where it should be applied. The \
pairwise Lists of rules (items desired to find in format to define a \
Getter) and fGetter (respectively, the function to apply to them) \
list all candidates to take into account.";

UseGetterPoint[t_List] :=
    Apply[t[[1]], #[[t[[2]]]]] &
UseGetterPoint::usage = 
  "UseGetterPoint[t_List][dataPoint] uses the Getter t in given data \
POINT.";

UseGetter[t_List] :=
    Map[t[[1]] @@ # &, Map[Part[#, t[[2]]] &, #]] &
UseGetter::usage = 
  "UseGetter[t_List][data] uses the Getter t in given data.";

StringPermutationPattern[l_List] :=
    Apply[Alternatives, Map[Apply[StringJoin, #] &, Permutations[l]]]

(*Rules for homonyms, they will be substituted latter to simplify the \
definition of getters*)
(*Canonical convention for internal definitions: \
[d|rel][max|min](x|y)
Note this is expressed in typical programming notation, i.e.,:
(~) means mandatory
[~] means optional
~|~ means either
*)
(*Note that names can be canonicided with \
"name"/.Reverse/@OtherNamingRules*)
OtherNamingRules = {"maxx" -> StringPermutationPattern[{"x", "max"}],
                   "minx" -> StringPermutationPattern[{"x", "min"}],
                   "dmaxx" -> StringPermutationPattern[{"x", "max", "d"}],
                   "dminx" -> StringPermutationPattern[{"x", "min", "d"}],
                   "dx" -> StringPermutationPattern[{"x", "d"}],
                   "relmaxx" -> StringPermutationPattern[{"x", "max", "rel"}],
                   "relminx" -> StringPermutationPattern[{"x", "min", "rel"}],
                   "relx" -> StringPermutationPattern[{"x", "rel"}],
                   "maxy" -> StringPermutationPattern[{"y", "max"}],
                   "miny" -> StringPermutationPattern[{"y", "min"}],
                   "dmaxy" -> StringPermutationPattern[{"y", "max", "d"}],
                   "dminy" -> StringPermutationPattern[{"y", "min", "d"}],
                   "dy" -> StringPermutationPattern[{"y", "d"}],
                   "relmaxy" -> StringPermutationPattern[{"y", "max", "rel"}],
                   "relminy" -> StringPermutationPattern[{"y", "min", "rel"}],
                   "rely" -> StringPermutationPattern[{"y", "rel"}]};

xRules = {{{"x"}, {"maxx", "minx"}}, {# &, #2 + (#1 - #2)/2 &}};
getXF[format_] :=
    FindGetter[xRules[[1]] /. OtherNamingRules, xRules[[2]], format];

xMaxRules = {{{"maxx"}, {"x", "dmaxx"}, {"x", "relmaxx"}, {"x", 
     "dx"}, {"x", 
     "relx"}}, {# &, #1 + #2 &, #1*(1 + #2) &, #1 + #2 &, #1*(1 + #2) \
&}};
getXMaxF[format_] :=
    FindGetter[xMaxRules[[1]] /. OtherNamingRules, xMaxRules[[2]], 
     format];

xMinRules = {{{"minx"}, {"x", "dminx"}, {"x", "relminx"}, {"x", 
     "dx"}, {"x", 
     "relx"}}, {# &, #1 - #2 &, #1*(1 - #2) &, #1 - #2 &, #1*(1 - #2) \
&}};
getXMinF[format_] :=
    FindGetter[xMinRules[[1]] /. OtherNamingRules, xMinRules[[2]], format]

yRules = {{{"y"}, {"maxy", "miny"}}, {# &, #2 + (#1 - #2)/2 &}};
getYF[format_] :=
    FindGetter[yRules[[1]] /. OtherNamingRules, yRules[[2]], format];

yMaxRules = {{{"maxy"}, {"y", "dmaxy"}, {"y", "relmaxy"}, {"y", 
     "dy"}, {"y", 
     "rely"}}, {# &, #1 + #2 &, #1*(1 + #2) &, #1 + #2 &, #1*(1 + #2) \
&}};
getYMaxF[format_] :=
    FindGetter[yMaxRules[[1]] /. OtherNamingRules, yMaxRules[[2]], 
     format];

yMinRules = {{{"miny"}, {"y", "dminy"}, {"y", "relminy"}, {"y", 
     "dy"}, {"y", 
     "rely"}}, {# &, #1 - #2 &, #1*(1 - #2) &, #1 - #2 &, #1*(1 - #2) \
&}};
getYMinF[format_] :=
    FindGetter[yMinRules[[1]] /. OtherNamingRules, yMinRules[[2]], format]


getterRules = {"x" -> getXF, "y" -> getYF, "maxx" -> getXMaxF, 
   "minx" -> getXMinF, "maxy" -> getYMaxF, "miny" -> getYMinF};

getData[format_, newFormat_, data_] :=
    Transpose[
     Map[UseGetter[#][data] &, 
      Through[(newFormat /. Reverse /@ OtherNamingRules /. getterRules)[
        format]]]]

(*A data is canonical if every coordinate in the set of points plotted is explicited*)
getCanonicalData[format_, data_] :=
    getData[format, {"x", "y", "xmin", "xmax", "ymin", "ymax"}, data]

(*Any of the points is directly obtained from the canonical data*)
getPoints0[data_] :=
    Map[{#[[1]], #[[2]]} &, data]
getPoints1[data_] :=
    Map[{#[[1]], #[[6]]} &, data]
getPoints2[data_] :=
    Map[{#[[1]], #[[5]]} &, data]
getPoints3[data_] :=
    Map[{#[[3]], #[[2]]} &, data]
getPoints4[data_] :=
    Map[{#[[4]], #[[2]]} &, data]

(*A function to scale log points. Negative values cannot be represented, thus we extend the error bar to show this.
BEWARE: If really small magnitudes are used (~E^-100) it won't work properly, but you wouldn't do that, do you?*)
ReLog = If[ # > 0,
            Log[#],
            -100
        ] &;
ScaleLog :=
    {#[[1]], ReLog[#[[2]]]} &
ScaleLogLinear :=
    {ReLog[#[[1]]], #[[2]]} &
ScaleLogLog :=
    {ReLog[#[[1]]], ReLog[#[[2]]]} &

getVerticalBars[data_, ScaleFunction_: Identity] :=
    Line[Transpose[
      Map[ScaleFunction, Through[{getPoints1, getPoints2}[data]], {2}]]]
getHorizontalBars[data_, ScaleFunction_: Identity] :=
    Line[Transpose[
      Map[ScaleFunction, Through[{getPoints3, getPoints4}[data]], {2}]]]

(*Data is defined to be a matrix of numbers*)
pData = x_List /; MatrixQ[x, NumberQ];
DataQ = MatchQ[#, pData] &;

(*A DataList is a List of Data*)
pDataList = x_List /; Apply[And, Map[DataQ, x]];
DataListQ = MatchQ[#, pDataList] &;

EnsureList=If[Head[#]===List,#,{#}]&;
EnsurePair=If[Head[#]===List,#,{#,#}]&;
AutoPad=PadRight[#1,#2,#1]&;

(*Only for M10*)

GetDefaultPlotStyle[theme_]:=Select[Select[
    Charting`ResolvePlotTheme[theme, 
     ListPlot], #[[1]] === Method &][[1, 2]], #[[1]] == 
    "DefaultPlotStyle" &][[1, 2]]
    
(*Get always as a List (possibly empty) *)
GetBaseStyle[theme_]:=If[(BaseStyle /. 
     Select[Charting`ResolvePlotTheme[theme, 
       ListPlot], #[[1]] === BaseStyle &]) === BaseStyle, {}, 
  EnsureList[
   Select[Charting`ResolvePlotTheme[theme, 
      ListPlot], #[[1]] === BaseStyle &][[1, 2]]]]


(*Options that are new to ErrorPlot*)
NewOptions={PointMarkers -> Automatic, ErrorBarTickSize -> 0.02, 
    ErrorBarTickStyle -> Automatic, 
    VerticalBarStyle -> Automatic,
     HorizontalBarStyle -> Automatic, PlotErrorBars -> {False, True}, 
    DataFormat -> Automatic};
    
Options[ErrorPlot] = Options[ListPlot]~Join~NewOptions;
Options[ErrorLogPlot] = Options[ListLogPlot]~Join~NewOptions;
Options[ErrorLogLinearPlot] = Options[ListLogLinearPlot]~Join~NewOptions;
Options[ErrorLogLogPlot] = Options[ListLogLogPlot]~Join~NewOptions;
Options[ErrorGeneralPlot]=Union[Options[ListPlot],Options[ListLogPlot],Options[ListLogLinearPlot],Options[ListLogLogPlot]]~Join~NewOptions;

(*Automatic values meaning are set depending on the version*)
AutoPointMarkers=If[$VersionNumber<=9.,Graphics[{Point[{0, 0}]}],
		Graphics[{PointSize[Medium], Point[{0, 0}]}]];


(*All error messages are shown by ErrorPlot (though raised by ErrorGeneralPlot)*)
ErrorPlot::invalidData = 
  "First argument is neither a List of numerical matrices nor one of \
such.";
ErrorPlot::noData = 
  "Not enough data to place the points in the graph. (x,y) cannot be \
guessed. Check option DataFormat.";
ErrorPlot::noBar = 
  "Not enough data to place the `1` error bars. Check option \
DataFormat.";
ErrorPlot::unidimensionalData = "Unidimensional data has no need for ErrorPlot. Consider using ListPlot.";

ErrorPlot[data_,opts : OptionsPattern[]]:=ErrorGeneralPlot[data,ListPlot,Identity,opts];
ErrorLogPlot[data_,opts : OptionsPattern[]]:=ErrorGeneralPlot[data,ListLogPlot,ScaleLog,opts];
ErrorLogLinearPlot[data_,opts : OptionsPattern[]]:=ErrorGeneralPlot[data,ListLogLinearPlot,ScaleLogLinear,opts];
ErrorLogLogPlot[data_,opts : OptionsPattern[]]:=ErrorGeneralPlot[data,ListLogLogPlot,ScaleLogLog,opts];



ErrorGeneralPlot[data_, plotFunction_,scaleFunction_,opts : OptionsPattern[]] :=
    Module[ {l,data2, canData, dataFormat,plotErrorBars,drawVerticalBars, drawHorizontalBars, barTickX, 
      barTickY, tickSize,errorBarTickStyle,horizontalBarStyle,verticalBarStyle,PointMarkerTable,defaultPlotStyle},
      data2=N[data];
      If[DataQ[data2],data2={data2}];
        If[ DataListQ[data2],
            l = Length[data2];
            If[Length[data2[[1,1]]]==1,Message[ErrorPlot::unidimensionalData];Abort[]];
            dataFormat = If[ OptionValue[DataFormat]===Automatic,
                             Switch[Length[data2[[1,1]] ],1,{"y"},2,{"x","y"},
                                 3,{"x","y","dy"},4,{"xmin","xmax","y","dy"},
                                 5,{"xmin","xmax","y","dy",""},
                                 _,{"x", "y", "xmin", "xmax", "ymin", "ymax"}],
                             OptionValue[DataFormat]
                         ];
            canData = getCanonicalData[dataFormat, #] & /@ data2,
            Message[ErrorPlot::invalidData];
                Abort[]
        ];
        If[ canData[[1, 1, 1]] === Null || canData[[1, 1, 2]] === Null,
            Message[ErrorPlot::noData];
            Abort[]
        ];
        plotErrorBars=EnsurePair[OptionValue[PlotErrorBars]];
        If[ plotErrorBars[[2]],
            If[ canData[[1, 1, 5]] === Null || canData[[1, 1, 6]] === Null,
                Message[ErrorPlot::noBar, "y"];
                drawVerticalBars = False,
                drawVerticalBars = True
            ],
            drawVerticalBars = False
        ];
        If[ plotErrorBars[[1]],
            If[ canData[[1, 1, 3]] === Null || canData[[1, 1, 4]] === Null,
                Message[ErrorPlot::noBar, "x"];
                drawHorizontalBars = False,
                drawHorizontalBars = True
            ],
            drawHorizontalBars = False
        ];
        tickSize=EnsurePair[OptionValue[ErrorBarTickSize]];
        barTickX = If[tickSize[[2]]==0,{},Line[{{-tickSize[[2]], 
            0}, {tickSize[[2]]*2, 0}}]];(*Tick ALONG X,i.e., for y error bars*)
        barTickY = If[tickSize[[1]]==0,{},Line[{{0, -tickSize[[1]]}, {0, 
            tickSize[[1]]*2}}]];
            
        (*M10's themes*)
        defaultPlotStyle=If[$VersionNumber<=9.,ColorData[1, "ColorList"],
        	GetDefaultPlotStyle[If[OptionValue[PlotTheme]===Automatic,$PlotTheme,OptionValue[PlotTheme]]]
          ];
        (*Override adding the BaseStyle*)
        If[$VersionNumber>=10.,defaultPlotStyle=Join[#, Directive @@ DeleteCases[GetBaseStyle[If[OptionValue[PlotTheme]===Automatic,$PlotTheme,OptionValue[PlotTheme]]],Automatic]]&/@ defaultPlotStyle];
        (*Other defaults*)
        errorBarTickStyle=AutoPad[If[OptionValue[ErrorBarTickStyle]===Automatic,defaultPlotStyle,EnsureList[OptionValue[ErrorBarTickStyle]]],l];
        PointMarkerTable = AutoPad[EnsureList[If[OptionValue[PointMarkers]===Automatic,AutoPointMarkers,OptionValue[PointMarkers]]],l];
        verticalBarStyle=AutoPad[If[OptionValue[VerticalBarStyle]===Automatic,defaultPlotStyle,EnsureList[OptionValue[VerticalBarStyle]]],l];
        horizontalBarStyle=AutoPad[If[OptionValue[HorizontalBarStyle]===Automatic,defaultPlotStyle,EnsureList[OptionValue[HorizontalBarStyle]]],l];

        
        plotFunction[
         Join[getPoints0 /@ canData, 
          If[ drawVerticalBars,
              getPoints1 /@ canData,
              {}
          ], 
          If[ drawVerticalBars,
              getPoints2 /@ canData,
              {}
          ], 
          If[ drawHorizontalBars,
              getPoints3 /@ canData,
              {}
          ], 
          If[ drawHorizontalBars,
              getPoints4 /@ canData,
              {}
          ]],
         FilterRules[{opts}, DeleteCases[Options[ListPlot], (Epilog -> _)]],
         PlotMarkers -> 
          Join[PointMarkerTable, 
           If[ drawVerticalBars,
               Table[Graphics[{errorBarTickStyle[[i]], 
                  barTickX}], {i, 1, l}],
               {}
           ],
           If[ drawVerticalBars,
               Table[Graphics[{errorBarTickStyle[[i]],
               	 barTickX}],  {i, 1, l}],
               {}
           ],
           If[ drawHorizontalBars,
               Table[Graphics[{errorBarTickStyle[[i]], 
                  barTickY}], {i, 1, l}],
               {}
           ],
           If[ drawHorizontalBars,
               Table[Graphics[{errorBarTickStyle[[i]], 
                  barTickY}], {i, 1, l}],
               {}
           ]],
           (*Note Partition makes the directives apply only to each bar series*)
         Epilog -> {If[ drawVerticalBars,
                        Partition[Riffle[verticalBarStyle[[1 ;; l]], 
                         getVerticalBars[#, scaleFunction] & /@ canData],2]
                    ], 
           If[ drawHorizontalBars,
               Partition[Riffle[horizontalBarStyle[[1 ;; l]], 
                getHorizontalBars[#, scaleFunction] & /@ canData],2]
           ], 
           OptionValue[Epilog]}]
    ]


End[]


EndPackage[]

