Starting Brainstorm
Brainstorm must be running in the background for these scripts to run properly. The interface doesn't have to be visible on the screen, but the database engine must be running for processing requests. At the beginning of your script, you can explicitly start or restart Brainstorm.

brainstorm: Start Brainstorm with the regular GUI.

brainstorm nogui: Start in silent mode. The Java GUI is created but hidden, the progress bar is not shown, all the processes run without user interactions, using default options instead of asking interactively. Visualization figures opened in the processing scripts are still created and made visible.

brainstorm server: Start in headless mode, for execution on a distant computation server that does not have any graphical capability or display attached to it. In this mode, none of the Java GUI elements are created, and the Matlab figures are not displayed. Whether you would be able to add screen captures to your execution reports depends mostly on the Matlab version available of your server (see section below Running scripts on a cluster).

brainstorm <script.m> <parameters>: Start Brainstorm in server mode, execute a script and quit Brainstorm. This allows executing any Matlab or Brainstorm script from the command line. This works also from the compiled version of Brainstorm, executed with the free MATLAB Runtime (see installation instructions, section "without Matlab"). Add the full path to the script and parameters to the command line:

Windows: brainstorm3.bat <script.m> <parameters>

Linux/MacOS: brainstorm3.command <MATLABROOT> <script.m> <parameters>
MATLABROOT: Matlab Runtime installation folder, eg. /usr/local/MATLAB_Runtime/v98/

brainstorm ... local: Instead of using a user defined brainstorm_db folder, it would use the default folder for the database: $HOME/.brainstorm/local_db