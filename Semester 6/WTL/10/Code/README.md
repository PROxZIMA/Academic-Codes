Enterprise Java Beans (EJB) Sample [![Build Status](https://travis-ci.org/WASdev/sample.ejb.svg?branch=master)](https://travis-ci.org/WASdev/sample.ejb)
==============


This sample demonstrates injection of an EJB into a servlet. The application consists of a servlet and stateless session bean. The servlet uses annotations to inject the stateless session bean, and then performs a call on the hello method of the bean.

This sample can be installed onto runtime versions 8.5.5.0 and later.

## Maven

The Liberty Maven plug-in and WebSphere Developer Tools support creating loose applications. This example creates a loose EAR application when building using Maven. After running the full build, you will see the application installed as `sample.ejb/ejb-ear/target/liberty/wlp/usr/servers/ejbServer/apps/ejb-ear.ear.xml`.

### Using Eclipse with Maven

1. Clone this project and import into Eclipse as an 'Existing Maven Project'.
2. Right-click the project and select **Run As > Maven Clean**.
3. Right-click the project and select **Run As > Maven Install**.
4. Right-click the project and select Run As -> Run on Server.
5. You should see the following in the console: `Application EJBSample started in XX.XX seconds.`

### Using the command-line with Maven

This project can be built with Apache Maven. The project uses the [Liberty Maven Plug-in] to automatically download and install the Liberty Java EE 7 Full Platform 7 runtime from [Maven Central]. The Liberty Maven Plug-in is also used to create, configure, and run the application on the Liberty server.

Use the following steps to run the application with Maven:

1. Execute the full Maven build. The Liberty Maven Plug-in will download and install the Liberty server in the `ejb-ear` project. It will also run all tests.
    ```bash
    $ mvn clean install
    ```

2. To run the server in the `ejb-ear` subproject:
    ```bash
    $ mvn --projects ejb-ear liberty:run-server
    ```
    The `--projects` and `-pl` are equivalent options.

In your browser, enter the URL for the application: [http://localhost:9080/ejb-war/ejbservlet/](http://localhost:9080/ejb-war/ejbservlet/)
In your browser, you should see the message "Hello EJB World".

## Gradle

This project can also be built with Gradle. The project uses the [Liberty Gradle Plug-in] to automatically download and install the Liberty Java EE 7 Full Platform runtime from [Maven Central]. The Liberty Gradle Plug-in is also used to create, configure, and run the application on the Liberty server.

The Liberty Gradle Plug-in supports creating loose application configuration for war tasks, but it does not yet support loose enterprise applications. This example installs the EAR file when building using Gradle. After running the full build, you will see the application installed as `sample.ejb/ejb-ear/build/wlp/usr/servers/ejbServer/apps/ejb-ear.ear`.

### Using Eclipse with Gradle
1. Go to *Help > Eclipse Marketplace > Install Buildship Gradle Integration 2.0*
2. Clone this project and import into Eclipse as an 'Existing Gradle Project'.
3. Go to *Window > Show View > Other > Gradle Executions & Gradle Tasks*
4. Go to Gradle Tasks view and run `clean` in build folder, then `build` in build folder, then `libertyStart` in liberty folder.
5. You should see the following in the console: `Application EJBSample started in XX.XX seconds.`

### Using the command-line with Gradle

Use the following steps to build and run the application with Gradle from the root project:

1. Execute the full Gradle build. The Liberty Gradle Plug-in will download and install the Liberty server in the `ejb-ear` project. It will also run all tests.
    ```bash
    $ ./gradlew clean build
    ```

2. To start the server with the EJB sample application run:
    ```bash
    $ ./gradlew libertyStart
    ```

    Alternatively, execute the run command:
    ```bash
    $ ./gradlew libertyRun --no-daemon
    ```

3. To stop the server, run:
    ```bash
    $ ./gradlew libertyStop
    ```

In your browser, enter the URL for the application: [http://localhost:9080/ejb-war/ejbservlet/](http://localhost:9080/ejb-war/ejbservlet/)
You should see the message "Hello EJB World".
