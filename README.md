# msi_dn1

# O virtualki

## Operacijski sistem
Izbrala sem Ubuntu 20.04 LTS, ker je najhitreje najti način inštalacije za večino zadev. 
Probala sem z sistemom Alpine Linux, ki je manjši in bi se zato virtualka hitreje postavila. Vendar sem hitro prišla do težave, da ne znam inštalirali gns3-gui in gns3-server gor.

## Grafični vmesnik
Za grafični vmesnik sem izbrala i3 window maganager. Saj prvi poskusi so bili s XFCE4 grafičnim vmesnikom, ki je provision time povečal za povprečno 5 minut.

## Tipkovnica
Pri vpisu je tipkovnica ameriška.
Po vpisu v i3wm je prvotno slovenska tipkovnica. Če želiš preklopiti na ameriško, to narediš z Windows_key + u. Za prehod nazaj na slovensko je Windows_key + s.
Alt + Enter -> odpre se terminal 
Alt + d -> odpre se iskalni meni
Alt + Shift + q -> aplikacija v ospredju se zapre
Alt + f -> aplikacija v ospredju gre fullscreen

Več keybinding-ov je na [njihovi spletni strani](https://i3wm.org/docs/userguide.html#_default_keybindings)

## Aplikacije
Naložene so aplikacije:
- gns3
- wireshark
- Docker, ki je potreben za pravilno delovanje gns3
- Midori (web browser za lažje oddajanje domačih nalog :) )
- xrdp

Gns3 pride z Wireshark-om v paketu, ki se ga inštalira. Docker se je naložilo iz njihovega repozotorija. Midori browser sem izbrala ker je med lightweight browserji.
xrdp je za RDP protokol izvajati, torej za Remote Access.

## Problemi, ki sem jih srečala
Pri xfce4 paketu je vmes interaktivni izbor, ki je bil problematičen, ker če ni nastavilo DEBIAN_FRONTEND=noninteractive provisioning ni deloval. Prav tako je to pri inštalaciji gns3 in Docker-ja. To sem probala rešiti s pisanjem v debconf-set-selections. Večinoma pa mi je izbralo default odgovor, ki se izbere, če imaš nastavilo DEBIAN_FRONTEND=noninteractive. Zato je bilo potrebno dodati vagrant uporabnika v skupino ubridge in Docker. Drugače ju uporabnik ne bi moral uporabljati. 

Naslednji problem je bil, da i3wm nastavi tipkovnico po defaultu na ameriško, kar predstavlja problem, če nisi navajen na njo in ugibaš kje je kateri znak. To sem rešila z dodajanjem v config datoteko.
```bash
# keyboard layout
set $ms Mod4
bindsym $ms+s exec setxkbmap si
bindsym $ms+u exec setxkbmap us
exec "setxkbmap -layout si"
```
Tako lahko uporabniki preklopljajo med slovensko in ameriško tipkovnico, glede na njihove želje. 

## Vpis
Klikneš na user ali vagrant
![vklop](/images/vklop.png)
Klikneš na kolešček in izbereš i3
![vpis](/images/vpis.png)
![vpis_2](/images/vpis_2.png)
Ter vpišeš geslo
Potem delaš glede na napotke v [Tipkovnica](#tipkovnica)


# Vagrant
Pojdi v datoteko Vagrant_way in poženi ukaze 
```bash
cd msi_dn1/Vagrant_way
sed -i 's/\r//' config
vagrant up
```
S tem se boš premaknil v ustrezno mapo, zagotovil ga ima config file pravilne končnice vrstic in generiral virtualko in lahko traja okoli 10 minut. 

```
ip: 127.0.0.1:3389
user_name: vagrant
password: vagrant
```
## Proces
1. Kreira se Ubuntu 20.04 LTS VM
2. Update in upgrade 
3. Inštalirajo se želeni paketi. Med njimi so paketi za i3 Window Manager, Docker, GNS3, Midori ter xrdp. Ter ustrezna aktivacija, kjer je potrebno. Za i3 Window Manager sem dodala default config datoteko s spremenjeno postavitev tipkovnice.
5. Ponovni zagon sistema.

## Problemi, ki sem jih srečala pri vagrantu

Ko se želim povezati z vagrant virtualko napiše
```
Povezave z drugo konzolno sejo v oddaljenem računalniku ni bilo mogoče vzpostaviti, ker v računalniku že poteka konzolna seja.
```

# Cloud-init
Pojdi v datoteko cloud_init_way in poženi ukaz za generiranje virtualke in lahko traja okoli 10 minut.
```bash
cd msi_dn1/cloud_init_way
multipass launch -n gns3VM --cloud-init cloud-config.yaml
```
ip ugotoviš z 
```bash
multipass list
```

```
ip: tvoj_ip:3389
user_name: user
password: ubuntumsi12
```

## Problemi, ki sem jih srečala pri cloud-initu
Prvi problem je bil že kako sploh vitrualko bootstrapat z cloud-initom na Azure-ju. To sem ugotovila, da je en izmed najmanjših kradratkov pravi prostor za kopiranje code od cloud-config.yml.
Drugi problem je bil, da se nisem mogla povezati gor. Ne preko RDP, kljub temu da naj bi bil port odprt in xrdp naložen, ne preko ssh, prav tako ne z Bastion. Zato sem probala s čisto prazno virtualko Ubuntu 20.04 gen 1, to je delovalo. Nato sem nadaljevala postopoma. Tako sem odkrila, da Docker pravilno naloži in deluje. Nato sem prešla na multipass.  
Sedaj glede na izpisano deluje in se vse naloži, še vedno se pa ne znam povezati na virtualko.
Wireshark doda user v skupino wireshark vendar ga nima user pravic uporabljati. Problema nisem razrešila.

## Proces
1. Kreira se Ubuntu 20.04 LTS VM
2. Zapiše se datoteka config in omogoči se ipv4 forwarding 
3. Kreirajo se skupine 
    - docker
    - ssl-cert
    - libvirt
    - kvm
    in uporabnika
    - xrdp s skupino ssl-cert 
    - user s skupinami ssl-cert, libvirt, kvm, docker
4. Update in upgrade ter inštalirajo se paketi:
    - xinit
    - i3
    - xrdp
    - midori
    - debconf-utils
    - apt-transport-https 
    - ca-certificates 
    - curl 
    - gnupg-agent
    - software-properties-common
    - docker-ce
    - docker-ce-cli
    - containerd.io
5. Izvede se runcmd, ker se naloži gns3-gui, gns3-server, wireshark. Dodamo uporabnika user dodamo v skupino ubridge. Prenesemo config file za i3 v pravilni direktorij in zaženemo i3. Zaženemo xrdp in odpremo port 3389 za tcp promet. 
6. Ponovni zagon sistema.
