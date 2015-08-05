#POD configuration

### 1- Install Pod
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

### 2- Install dependencies
Pod yüklendikten sonra Podfile içerisinde bulunun kütüphanelerin pod komutu ile yüklenmesi gerekilmektedir. Bunun için PodFile'ın bulunduğu directory'e gidilip aşağıdaki komut çağırılır.
```
pod install
```

Bu aşamadan sonra kütüphanelerin kullanılması sorun olmayacaktır. Proje dosyaları içerisinde <b>youbaku2.xcworkspace</b> ya da genel olarak <b>lorem.xcworkspace</b> gibi bir file oluşacaktır. Bu file ile proje açılmalıdır.

* [Useful link](http://www.raywenderlich.com/64546/introduction-to-cocoapods-2)
