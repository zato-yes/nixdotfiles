pragma Singleton
import Quickshell
import Quickshell.Io

Singleton {
    property alias wallpaperPath: adapter.wallpaperPath

    FileView {
        path: Quickshell.statePath("config.json")   
        watchChanges: true
        onFileChanged: reload()
        onAdapterUpdated: writeAdapter()
        adapter: JsonAdapter {
			id: adapter
			property string home: Quickshell.env("HOME")
            property string wallpaperPath: home + "/nixdotfiles/wallpapers/nixwal.png"
        }
    }
}
