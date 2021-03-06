<script id="HBtweetContainer" type="text/x-handlebars-template">

</script>

<script id="HBkeywordContainer" type="text/x-handlebars-template">

</script>

<script id="HBaddContainer" type="text/x-handlebars-template">
    <div class="center-outer">
        <input placeholder="Enter Keyword" class="center-inner left" size="17" type="text"/><a class="button center-text center-inner right">Add</a>
        <input type="checkbox"/>
    </div>
</script>

<script id="HBkeywordContainerEmpty" type="text/x-handlebars-template">
    <p class="instructions message">
        There are no currently active keywords. Please enter one in the box above to get started!
    </p>
</script>

<script id="HBkeyword" type="text/x-handlebars-template">
    <div class="keyword clearfix">
        <a class="keyword-remove center-text">X</a>
        <div class="icon left center-text">{{text}}</div>
        <div class="graph left center-outer">
            <div class="count-lower">#<span class="num-seen">{{numSeen}}</span>
            </div>
            <div class="bar center-inner">
                <div class="count-upper">#<span class="num-seen">{{numSeen}}</span></div>
            </div>
        </div>
    </div>
</script>

<script id="HBtweet" type="text/x-handlebars-template">
    <div class="tweet {{class}}">
        <div class="header">
            <img src="{{imageUrl}}" alt="userImage"/>
            <div class="right">{{userName}}</div></div>
        <div class="text clearfix">{{text}}</div>
    </div>
</script>

