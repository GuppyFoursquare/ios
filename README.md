#POD configuration

### 1- Setup Pod
Öncelikle makinamızda pod yüklü değilse yüklenilmesi gerekilmektedir. Bunun için aşağıdaki komutlar çağırılır.
```
sudo gem update --system
sudo gem install cocoapods
```
Son olarak aşağıdaki komut çağırılarak yükleme işlemi gerçekleştirilir.
```
pod setup
```

NOTE :: Bu aşamada ```pod init``` kullanılmasına gerek yoktur. Bu komut Podfile'ın oluşmasını sağlamaktadır. Ancak bulunduğumuz repository içerisinde Podfile bulunduğundan bu işlem gerekmemektedir.

### 1.1- Setup Pod ERROR
Bazı durumlarda pod setup etme işleminde Cloning into `master` hatası vermektedir. Bunun engellemek ve setup işlemini düzgün yapabilmek için aşağıdaki komutlar çağırılır.
``` 
pod repo remove master
pod setup --verbose
```

Buradaki setup komutunda verbose çağırılmasının sebebi işlemi izlemek içindir. 

* [İlgili link](http://stackoverflow.com/questions/21680573/cocoapods-setup-stuck-on-pod-setup-command-on-terminal#answer-23447657)

### 1.2- Setup Pod ERROR
Ayrıca utf-8 kullanıldığından emin olunması gerekmektedir. Emin olunamıyorsa export utf-8 komutu çağırılmalıdır.
```
export LC_ALL=en_US.UTF-8  
export LANG=en_US.UTF-8:
```

### 2- Install dependencies
Pod yüklendikten sonra Podfile içerisinde bulunun kütüphanelerin pod komutu ile yüklenmesi gerekilmektedir. Bunun için PodFile'ın bulunduğu directory'e gidilip aşağıdaki komut çağırılır.
```
pod install
```

### 3- PodFile
PodFile ismi ile oluşturulan file içeriği aşağıdaki gibi olmalıdır.
```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '7.1'
pod 'GoogleMaps'
pod "MWPhotoBrowser"
```
Bu aşamadan sonra kütüphanelerin kullanılması sorun olmayacaktır. Proje dosyaları içerisinde <b>youbaku2.xcworkspace</b> ya da genel olarak <b>lorem.xcworkspace</b> gibi bir file oluşacaktır. Bu file ile proje açılmalıdır.

* [Useful link](http://www.raywenderlich.com/64546/introduction-to-cocoapods-2)
