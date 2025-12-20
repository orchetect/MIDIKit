# MIDIKit DocC Generation

## Build and Publish

The docs generation procedure is mostly automated, but requires a handful of manual procedures that are not yet automated in order to build and publish.

1.  Run the `build-docc-cached-preview.sh` command from Terminal from within the repo directory

    - If any DocC warnings are shown:

      1. resolve the issues in the codebase
      2. re-run the build script and repeat resolving issues until no more warnings are present
      3. make a commit

    - When finished the generated docs path will be output to the console, ie:

      ```
      Generated combined documentation archive at:
        /var/folders/pk/3smbhvrd0p701_rpq3t0c_2r0000gn/T/tmp.Oq9smpNmnD/docs-webroot/MIDIKit
      ```

      As well, a local webserver on port 8080 will run to preview the documentation in a local web browser at this URL:

      http://localhost:8080/MIDIKit/documentation

2.  Press `Ctrl+C` in the Terminal window to shut down the local webserver and return to the shell prompt

3.  Navigate to the generated docs path using the path that was output to the console

    ```bash
    cd /var/folders/pk/3smbhvrd0p701_rpq3t0c_2r0000gn/T/tmp.Oq9smpNmnD/docs-webroot/MIDIKit
    ```

    Then to open this folder in the Finder:

    ```bash
    open .
    ```

4.  In the local repo `docs` branch:

    - remove all files within the `docs` subfolder except `index.html`
    - copy all files from the generated docs `except index.html` to replace the old docs that were deleted

5.  See the [Post-Build](#Post-Build) section below

6.  Commit and push to remote `docs` branch - GitHub Actions will automatically publish the site to GitHub Pages

## Post-Build

The root-level `index.html` file in the local repo `docs` branch needs to edited to include a meta event to redirect to the documentation subpath.

```html
<head>
    <!-- ... -->
    <meta http-equiv="refresh" content="0; url=documentation/">
```
