# multidex-maker

A dex tool which ensures the specified class in the specified secondary dex.

# Purpose

Because the Android apps usually consist of independent modules,  I had  modified the dx tool of AOSP to keeping each module in a separate dex, benifits are as follows:

* A small enough main dex to avoid [main dex capacity exceeded](http://ct2wj.com/2015/12/22/the-way-to-solve-main-dex-capacity-exceeded-in-Android-gradle-build/).
* Improving the startup time of app due to the minimum size of main dex.
* Installing of the secondary dexes is more controllable, so we can do something interesting. (e.g. record load time of each module)


# Installation


1) Exec shellscript

```
./install.sh
```

2) Modify buildscript

```
build.gradle
```
```groovy
android {
    afterEvaluate {
        tasks.matching {
            it.name.startsWith("dex")
        }.each { dx ->
            if (dx.additionalParameters == null) {
                dx.additionalParameters = []
            }
            dx.additionalParameters += "--main-dex-list=$projectDir/maindexlist.txt".toString()
            dx.additionalParameters += "--secondary-dexes-list=$projectDir/secondarydexeslist.txt".toString()
            dx.additionalParameters += "--minimal-main-dex"
        }
    }
}
```

3) Add secondarydexeslist.txt

Exmaple:

```
--secondary-dex-begin    
com/github/jllk/multidex/sample/R
--secondary-dex-end

--secondary-dex-begin    
scala/
--secondary-dex-end

--secondary-dex-begin	
com/github/jllk/multidex/sample/a/
--secondary-dex-end

--secondary-dex-begin
com/github/jllk/multidex/sample/b/
--secondary-dex-end

--secondary-dex-begin
com/github/jllk/multidex/sample/c/
--secondary-dex-end

--secondary-dex-begin
com/github/jllk/multidex/sample/d/
--secondary-dex-end
```

4) Apply multidex-installer and multidex-hook

`build.gradle`


```groovy
dependencies {
    compile fileTree(dir: 'libs', include: ['*.jar'])
    compile "com.github.jllk:multidex-installer:0.0.4-beta@aar"
    compile "com.github.jllk:multidex-hook:0.0.1-beta@aar"
}
```




`Application`:

```scala
class SampleApp extends Application {

  override def attachBaseContext(base: Context): Unit = {
    super.attachBaseContext(base)
    JLLKMultiDexInstaller.installOne(this, 2) // for R
    JLLKMultiDexInstaller.installRange(this, 3, 4) // for scala

    JLLKMultiDexHook.lazyInstall(SampleModuleMgr.getConfig)
  }
}
```

# Outcomes

After building we get main dex and secondary dexes in order, and we can load part of them or all:

```
> du -sh *.dex
40K	classes.dex
4.0K	classes2.dex
7.0M	classes3.dex
1.7M	classes4.dex
12K	classes5.dex
12K	classes6.dex
12K	classes7.dex
12K	classes8.dex
28K	classes9.dex
```

# See also

multidex-installer: [https://github.com/JLLK/multidex-installer](https://github.com/JLLK/multidex-installer)

multidex-hook: [https://github.com/JLLK/multidex-hook](https://github.com/JLLK/multidex-hook)

multidex-sample: [https://github.com/JLLK/multidex-sample](https://github.com/JLLK/multidex-sample)

# License

This tool is licensed under Apache License 2.0. See LICENSE for details.