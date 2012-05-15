<style>
    code {
        border: 2px solid #EAEAEA;
        background-color: #F8F8F8;
        border-radius: 5px;
        width: 80%;
        margin: 0 auto;
        padding: 1.5em;
        display: block;
    }

    a {
        color: #4183C4;     
        text-decoration: none;
    }

    a:hover {
        text-decoration: underline;
    }
</style>

Gr8Conf 2012 Workshop Guide
========

The purpose of this document is to provide a brief description of each Javascript library we will use and to guide the reader through the process of building or sample app, twitterMonitor.

Structure - [Backbone.js][backbone] (and [Underscore.js][underscore])
------------

Backbone.js provides exactly what it sounds like: a solid foundation from which to build a large Javascript based web app. It provides structure and functionality for Models and their corresponding Views, Collections, History, and a custom Event system. It allows a developer to quickly set up synchronization between a model and the server. It does not, however, provide much in the way of Controller structure, and is thus up to the developer to handle that portion of the application. Backbone has two requirements: [Underscore.js][underscore] ( a functional 'utility belt' which Backbone takes advantage of) and either [jQuery][jquery] or [Zepto][zepto].

I encourage you to read through the Backbone [documentation][backbone] (or at least have it open as a reference) during this project, but I highlight here a few important bits to keep in mind.

First off, when creating a new Backbone object, one 'extends' a from a base type, like so: 

    var keyword = new Backbone.Model.extend({options});


The extend method accepts an options parameter, which is a normal JS object that contains additional functionality. A base Backbone object inherits quite a bit of functionality, but the options parameter can override anything you wish. For example, each Backbone object contains a contsructor method called 'initialize' which is empty by default.


Below are listed some important features and methods from each object type

### [Models](http://backbonejs.org/#Model)

Models typically act as a direct mapping from an object on your server to one in your UI. Each Backbone model knows how to access it's mapped Model (by default via a pure REST implementation) and allows a range of functionality, including performing client-side validation of objects.

#### fetch({options})
The fetch method pulls information from the server and updates the model with any new data. If data has been changed, a 'changed' event is fired from this object. The options parameter allows for 'success' and 'error' callback methods.


### [Views](http://backbonejs.org/#View)

Just like you'd imagine, Views are responsible for rendering and code surrounding the DOM nodes they've created. When creating a new view, one typically attaches the model, then calls render() followed by bindEvents() (or use a [declarative events](http://backbonejs.org/#View-delegateEvents) object). One nice feature is that Backbone encourages the use of JS Templates.

#### render()
Responsible for rendering some set of nodes, typically based on a model. If done nicely, a typical render method may look something like this:

    render: function () {
        
        this.$el.html($(TM.Templates.tweet({
            text: this.model.get("text")
            })));
        return this;
    },

Note the use of 'return this'. A view is *not*, by convention, responsible for inserting itself in the DOM; that task generally falls to whatever created the view. Also, the this.$el object, which is a cached jQuery/Zepto selector for the view's root node.

### [Collections](http://backbonejs.org/#Collection)

Collections provide a range of convenience methods for managing ordered sets of Models. One of the most features is the ability to hook into a 'list' type action on the server to auto-instantiate a set of Models.



Templating - [Handlebars][handlebars]
--------------

Based on the Mustache template format, Handlebars is an excellent choice for building Javascript templates. Usage is simple: create a set of Templates (which contain named placeholders for data) and compile them, which transforms them into a Javascript function. This function accepts a context, an object containing data mapped to your named placeholders, and returns a string which one can inject into your page as a DOM element. 

Templates can placed in an HTML page as a node that your scripts must locate, or included as escaped strings in your JS. 


Testing - [Jasmine][jasmine]
----------

Jasmine is a BDD testing framework for Javascript. The library creates a highly readable DSL for describing your tests, which are referred to as 'specs'.


About this App
======

The included Grails application, called 'twitterMonitor', is intended as an introduction in how to build responsive, API-driven, Javascript-heavy applications. The overall purpose of this sample application is allow a user to monitor Twitter for a set of keywords. The number of occurences are tallied & displayed to the user, as well as a feed of the messages themselves.

While all code is bundled within one application, it is helpful to think of this as two separate applications, the client-side portion and the server-side piece. The server-side component is largely already complete, and this guide instead focuses on how to rebuild the client-side code. Below are high-level descriptions of each side

### Server

The twitterMonitor server will receive data from the front-end, either a string representing a keyword to add or a number representing the id of a keyword to delete. It will also send data about the keywords and saved tweets to any client in JSON format. 

The server also periodically executes two Quartz jobs: one which deletes tweets older than a specific threshold, and another which searches Twitter for new tweets containing the keywords. When a keyword is first searched, twitterMonitor will grab the previous n tweets (where n is a config option), but subsequent searches will return new tweets in between the last seen tweet. Keywords with matches will have a counter increased, and matching tweets are saved, then subsets of data are sent to the client.


### Client

The twitterMonitor client, once complete, will display information about keywords and tweets. The UI will contain three major visual components: a 'control' area (allows a user to input new keywords and start/stop the Client to server communication), the keyword area (displays each keyword with number of occurences and a bar graph expressing relative counts), and the tweet queue (displays tweets containing the keywords).


### File Locations

Nearly every file we add or edit today will be within web-app/js/src/. Please note that if the reader changes any file names or adds new files, the file must be added to the ApplicationResources.groovy in grails-app/conf so that the Resources plugin will bundle it for you. 


Instructions
=====

The following guide will walk you through the steps needed to build the twitterMonitor UI; please follow it at your own pace. A few notes: 

1.  Try to JS objects and CSS class names the same as the guide; otherwise you'll need to change the corresponding values in multiple places
2.  This guide assumes that the reader has created a Grails app before, and is aware of the standard file locations and commands
3.  I apologize ahead of time for any bugs that may have crept in.
5.  Refer to the [Backbone.js][backbone] or [Jasmine][jasmine] docs often for further clarification.
4.  Be Creative! It is just a guide; there's much more that could be done with the information here. For example, the underlying service could be updated to capture much more information about each tweet, which could lead to more in-depth UIs. Also, the Tweet queue intentionally does not use a Collection; one could edit it to make use of the Collection object.


### Getting Started

I'll assume that you 1) have the full twitterMonitor project (e.g. downladed the repo from github) and 2) you have grails version 2.0.3 installed. Great. Now:

1.  See if there's anyone in the room without a computer, who may be looking around nervously. Buddy up with them and offer to pair program!
2.  Start the application with 'grails run-app'

At this point, navigate to [http://localhost:8080/twitterMonitor](http://localhost:8080/twitterMonitor); you should see a blue banner with the words 'Twitter Monitor' and a blank white screen.

Let's get started!

#### 1. Models


We will need to create two models: Keyword and Tweet.

*   Locate and open the the file <strong>web-app/js/src/models/tweet.js</strong> 
*   Create the model and add it to our TwitterMonitor JS namespace by typing:  


        TM.Models.Tweet = Backbone.Model.extend({});


Congratulations, you've created your first Backbone Model! We could certainly make this more complicated by adding verifications, defaults, etc, but it's not necessary for this demonstration. We've successfully extended the default BackboneModel into our own Tweet Model, and namespaced it into TM.Models (see <strong>web-app/src/js/core/base.js</strong> for a further breakdown on the namespacing).

*   Locate and open <strong>web-app/js/src/models/keyword.js</strong>
*   Add the following: 

        TM.Models.Keyword = Backbone.Model.extend({ 
            url: function () { 
                return "/twitterMonitor/keyword/" + this.get("id"); 
            } 
        }); 

We've just created our second Model, this time extendeding it's base functionality by defining a <strong>url</strong> function. Backbone will use an Object's <strong>url</strong> function or object (you can use either) to know how to uniquely fetch this model's data; it should map to our keyword's endpoint on the server. 
We're not quite finished with the model yet; let's add a function to help calculate the relative size of the keywords hit count. The function should return a ratio of its 'numSeen' variable to that of the other keywords. We can take advantage of this by using the model's <strong>collection</strong> parameter.

*   Enter the following (or something similar) into the Model's extend object: 
    
        getBarPercentage: function () {
            var maxSeen = this.collection.getMaxNumSeen(),
                percentage = (this.get("numSeen") / maxSeen) * 100;
            // ensure a max percentage of 100
            if (percentage > 100) {
                percentage = 100;
            }
            return Math.round( percentage );
        }


In the code, 'this' refers to the model itself (you may note that throughout I often cache 'this' into a local variable named 'self' in the cases where 'this' will be of an improper scope). The 'collection' parameter is a reference to a collection object that the model is a member of; we'll create the 'getMaxNumSeen' function later on, when we create the Collection. 

*   Let's set a default value for 'numSeen'. Add the following to the Model's extend object:  

        defaults: {
            "numSeen": 0
        } 


Make sure to separate each of our objects/functions within the extend object with commas! In the end, you should have something like this: 

        TM.Models.Keyword = Backbone.Model.extend({
            defaults: {
                "numSeen": 0
            },

            url: function () {
                return "/twitterMonitor/keyword/" + this.get("id");
            },

            // Returns the relative percentage of the bar graph's width compared with the other models in the collection
            getBarPercentage: function () {
                // A model that becomes part of a collection gets assigned a reference
                var maxSeen = this.collection.getMaxNumSeen(),
                    percentage = (this.get("numSeen") / maxSeen) * 100;
                // ensure a max percentage of 100
                if (percentage > 100) {
                    percentage = 100;
                }
                return Math.round( percentage );
            }

        });

#### 2. Collections

Seeing as how we reference the Collection in the previous section, let's work on that next. Collections are a great way for managing groups of Models; they provide Array-esque methods for adding/removing, events for when items are altered, and (my favorite) access our keyword/list end point to automatically instantiate our set of keywords.

*   Open up <strong>web-app/src/js/collections/keywords.js</strong> and enter the following:

        TM.Collections.Keywords = Backbone.Collection.extend({
            url: "/twitterMonitor/keyword", // maps to the 'list' action on our server 

            model: TM.Models.Keyword,

            // in addition, this collection also keeps track of the current maximum 'numSeen' of the models in its care
            // this maximum is used to help set the width of the bar graphs on each keywords' view. The width of the bar graph
            // is relational to the keywords' current count versus the others (i.e. the bar graph will have a max width of 100%)
            //
            // Thus, we default to 100
            defaultMax: 100,
            maxNumSeen: 0,

            initialize: function () {
                this.maxNumSeen = this.defaultMax;
            }
        });

We do not use the 'defaults' object here to help highlight the constructor function 'initialize'. This collection, beyond simply holding and syncing the Keywords, should also be aware of the maximum 'numSeen' value in its keywords, so that each keyword can know its proper relative width that its View will display. The Collection's maxNumSeen value should return either maxNumSeen or the defaultMax (100), whichever is greater.

*   Add the following to your extend options object:

        // returns maxNumSeen or defaultMax, of maxNumSeen has not been set yet
        getMaxNumSeen: function () {
            return this.maxNumSeen ? this.maxNumSeen : this.defaultMax;
        }

But now we need a function that will discover the maxNumSeen for us. Luckily, we can make use of the Collection's 'pluck' function.

*   Add the following function: 

        findMax: function () {
            // the 'pluck' function extracts a value from each model in this collection, and places those values in an Array
            var counts = this.pluck("numSeen"),
                i = counts.length,
                max = 0;

            while (i--) {
                if (counts[i] > max) {
                    max = counts[i];
                }
            }
            this.maxNumSeen = max > this.defaultMax ? max : this.defaultMax;
        }

That's nice, but when should we search the models for the maximum? Whenever we call getMaxNumSeen? We could... but that's no fun. Let's instead hook into the Collection's event system! Whenever a member Model is added, removed, or updated, the Collection fires events that we can listen for. Where should we listen for these events? There's an argument to be made to add the bindings during the initialize function, however, Backbone Views have a convention where we separate the rendering of an item and the binding of its events. Let's extend that notion to our Collection.

* Add something similar to the extend options object:

        bindEvents: function (){
            var self = this;
            // "reset" is fired when the collection is created or reloaded
            this.on("reset", function (){
                self.findMax();
            });
            // "change is fired when a value in the collection is altered or a new item is added"
            this.on("change", function () {
                self.findMax();
            });
            // "destroy" is fired when a model is removed
            this.on("destroy", function () {
                if (self.models.length === 0) {
                    // alert the higher-ups that the collection is empty
                    self.trigger("empty");
                }
            })
        }













[backbone]: http://backbonejs.org/  "Backbone.js"
[underscore]: http://documentcloud.github.com/underscore/  "Underscore.js"
[handlebars]: http://handlebarsjs.com/ "Handlebars Templating"
[jasmine]: http://pivotal.github.com/jasmine/ "Jasmine BDD Testing"
[jquery]: http://jquery.com/ "jQuery"
[zepto]: http://zeptojs.com/ "Zepto.js"