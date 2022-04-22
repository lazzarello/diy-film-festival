# DIY Film Festival

aka

# Pirate Television

Some intro about the history of this fun pirate TV situation. Shout outs to

* Spectacle Theater
* CathodeTV
* Fort90 at Wonderville
* Museum of Home Video
* Moviepass
* Miss Molly Rogers
* Unlimited Hangouts
* Piss Hospital
* Sicko Vision

# HWG
 
This will require a minimum of five (5) different accounts on four services. So it's definitely some assembly required, thus the name DIY Film Festival.

1. Github account.
2. Account on ok.ru. Feels shady but it's probably fine.
3. Account on restream.io. Can do OAuth via Google. Nice.
4. restream.io's default ok.ru integration.
5. Account with minnit.chat

The good news is most of these are free. They are also easy to use.

## Hosting

### Github Pages (zero dollars)

Github is a platform used by software engineers to to develop code collaboratively. It also can host websites, neat! Here's how to set one up.

1. Create an account on Github.
2. Fork this repository by clicking the icon that says fork.
3. When you see a screen looking similar to this one again, click the little gear that says Settings
4. In the left menu that says Code and automation, click Pages
5. Under Source, from the pulldown select `main` and click Save
6. After a moment there should be a link to a URL where you can view this website, like, right now

(optional) Add a custom domain name
8. Add a domain (more on this in the DNS chapter) through Settings => Pages => Add a domain
  1. Type a domain where you can read and write records.
  2. Follow the instructions on the screen (depends on existing DNS hosting).
  3. Click Verify. The warning that it may take 24 hours was not relevant for my first attempt. It took about 5 minutes.
[Read the docs for more info on how Pages work, if you're curious](https://docs.github.com/en/pages/quickstart)

### Squarespace (non-zero dollars)

This seems to be popular too. I haven't used it so can't be the best voice here. Perhaps someone else can write up Squarespace docs.

## Video Streaming

### Audience delivery with ok.ru (zero dollars)

this site doesn't seem to have any limits on how many users can view an embedded video. Neat!
Give a custom name to a profile:
Settings => General => Profile Link
Not sure how to make a persistent URL for each stream. restream seems to make dynamic URLs for each broadcast and I have to update the HTML on the static site.

the embed links to https://ok.ru/live/3674825825876 which is how it worked when I had the link on keep notes but I think this URL changes each time  :(

### Delivery proxy with Restream.io ( 4 hours a week for zero dollars )

Restream sits between OBS and the audience. For a considerably higher amount of money, it can also do audience delivery. More on that later. It makes it easy to add a single stream key to OBS in a set-it-and-forget-it way. After that it will rebroadcast (restream, get it?!) to a multitude of other popular platforms like Twitch and Facebook. We're not concerned about these basic-ass platforms, so we first head to russia, as described in the preceding chapter.

After creating an account on ok.ru from the next chapter...
Create a destination using the default ok.ru template. If you are logged in to that platform it'll ask for permission and hook up the source.
Go back to OBS and click Start Streaming in the main window.

### Video encoding with OBS (free and open)

Default restream.io stream destination. Go to Settings => Output => Video Bitrate = 5000
Add VLC Video Source under Sources, add files to the playlist.
Move to the next chapter.

## DNS

### Github Pages (zero dollars)

If you don't care about a URL ending in github.io, you can keep the default from the tutorial. For example, the author's is http://lazzarello.github.io

### Custom DNS with name dot com (variable pricing)

Depending on the name you which to register and if it's available, this runs about $15 a year.
Post the instructions from Github Pages for custom DNS.

DOCO https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site
Create an "apex domain" at your DNS provider if you want a URL like example.com to go to the same place as stream.example.com.
Create the CNAME record to point to the Github Pages load balancer.
Click the Enable TLS thing to do the encryption we all deserve
