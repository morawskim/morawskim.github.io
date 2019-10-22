# flex wyśrodkowanie pionowe elementów

Wyśrodkować pionowo elementy można za pomocą kontenera `flex`.
Wcześniej były z tym sporo problemów.
Poniższy przykład jest dla biblioteki `React.js` wraz z material design.

```
<div style={{display: "flex", alignItems: "center"}}>
    <Icon>warning</Icon>
    <span>Lorem ipsum</span>
</div>
```

![flex alignItems](/images/Screenshot_20191017_110904.png)

[Live demo](https://codesandbox.io/s/material-demo-s2o43)


Możemy także dodać margines między tekstem a ikoną.
```
<div style={{ display: "flex", alignItems: "center" }}>
  <Icon>warning</Icon>
  <span style={{"display": "inline-block", marginLeft: "10px"}}>Lorem ipsum</span>
</div>
```