'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';
const RESOURCES = {
  ".git/COMMIT_EDITMSG": "9d54fa792fbf26e0a5e5b5435f229c0e",
".git/config": "910e81cbf88ff0cfaa72d6bd6053bb8f",
".git/description": "a0a7c3fff21f2aea3cfa1d0316dd816c",
".git/HEAD": "4cf2d64e44205fe628ddd534e1151b58",
".git/hooks/applypatch-msg.sample": "ce562e08d8098926a3862fc6e7905199",
".git/hooks/commit-msg.sample": "579a3c1e12a1e74a98169175fb913012",
".git/hooks/fsmonitor-watchman.sample": "ecbb0cb5ffb7d773cd5b2407b210cc3b",
".git/hooks/post-update.sample": "2b7ea5cee3c49ff53d41e00785eb974c",
".git/hooks/pre-applypatch.sample": "054f9ffb8bfe04a599751cc757226dda",
".git/hooks/pre-commit.sample": "01b1688f97f94776baae85d77b06048b",
".git/hooks/pre-push.sample": "3c5989301dd4b949dfa1f43738a22819",
".git/hooks/pre-rebase.sample": "56e45f2bcbc8226d2b4200f7c46371bf",
".git/hooks/pre-receive.sample": "2ad18ec82c20af7b5926ed9cea6aeedd",
".git/hooks/prepare-commit-msg.sample": "2b5c047bdb474555e1787db32b2d2fc5",
".git/hooks/update.sample": "517f14b9239689dff8bda3022ebd9004",
".git/index": "7cae8b65f07d3e756339f42fed52767c",
".git/info/exclude": "036208b4a1ab4a235d75c181e685e5a3",
".git/logs/HEAD": "4a7b65f7d20bd779706e75aef3d87bfb",
".git/logs/refs/heads/master": "4a7b65f7d20bd779706e75aef3d87bfb",
".git/logs/refs/remotes/origin/pages": "5ef9430f6aea710efd84216feca4b40d",
".git/objects/00/8a4a34a290c8d4f18028917f1f5b2c6fcfe740": "46763c2a469a54c1443c735f2713e834",
".git/objects/01/3b461caea6aec28c244ef35df4ddc623ba01df": "e5f580216b92c2cf2f09cd570762db8c",
".git/objects/13/5a3f566ef0f67f055309dc4ab65aa26ac69967": "b9e902e0488ad9c20b4e1c6698a09098",
".git/objects/20/5bb5db271c6d8de8399864c7bb9b917f638893": "c993b22f115d7f3ae6d5b7b212806539",
".git/objects/22/c6ea5eed3e08ef96e7cf7b957e81259cadf097": "1614f238531820d0b667d4dde4ca1f2d",
".git/objects/27/64116aeb647bbafeddaf1f89a19fe4cb8086f1": "ccdfb8947c591f17e736dd66d981431a",
".git/objects/33/7d5f1f3908eb665b9848acffcdda29b22a33e0": "7f8ad54f758df5f300165d4d676db188",
".git/objects/48/c60537bb72a429f7cf387ed6ca3423b51445bb": "fee84fe17a10b9a52f57805496869e72",
".git/objects/51/c2eb8c254f5a4c92420b4d2d46b4d9ccfbdac2": "8411d6193a396e55b48db9abc6a5eddc",
".git/objects/59/314026e7aefc697b654e46fbeb40f7843569b9": "446f977ab6277a4f9aa42b4cf15615dd",
".git/objects/5a/2ee64e8f2a8bcbbe8632b5e212742ce4f9dbcd": "da7a69bbd987d7613cc8e1d589fc7977",
".git/objects/5c/755fd942ff263f04b914b660a1ace788ca5c8e": "ff0081dc04d82c48002ef52e8da50e45",
".git/objects/5c/ab0f911f7e40e0eca1beb326b692371771bfc7": "f13ac1651d3dea7713a6860abf1338b4",
".git/objects/76/0c457bf09cbd8ed623509b4961e1c5e1ec1441": "5fabbb3c666e9628bdf4c0b0d6acfc30",
".git/objects/76/8b235dd54c8fff799c5313b5e98d89bebb2940": "bb3e1eeaaadf318745651a8063d9ca94",
".git/objects/88/cfd48dff1169879ba46840804b412fe02fefd6": "e42aaae6a4cbfbc9f6326f1fa9e3380c",
".git/objects/8a/aa46ac1ae21512746f852a42ba87e4165dfdd1": "1d8820d345e38b30de033aa4b5a23e7b",
".git/objects/8f/8b68ffbe42e2bcb6574268d77fd6f14934f9bf": "327a1dbd45efed41901ba8eda86b8e44",
".git/objects/a8/1d749a42d08923ce1e6c1c2eb33ca6e39f1e26": "a6748270702bf1608a53c4b15dea8598",
".git/objects/a8/3a17d54b6dc2156c855c6580301cefc9c8d017": "6525101be8d70b808a809af9c83fa4ad",
".git/objects/a9/cb2b23cc227f94f5622eac75afdee4dc678bcf": "32cb5c0530eecf4c7f16a7114daf3662",
".git/objects/b2/7565f857cb894f1cefb370de74fb6ac1814b29": "0b4868561b526a22dcad261127df056c",
".git/objects/b7/49bfef07473333cf1dd31e9eed89862a5d52aa": "36b4020dca303986cad10924774fb5dc",
".git/objects/b9/dc1d110bd52fa4a2cc3c8c3d157d0a75c0794c": "505a945deb90aea2e31876662fca57b5",
".git/objects/bf/1003029ef1ff9258d9b77ef57d2125d7c570de": "89dbda870eca86705e2f372a9dec8a12",
".git/objects/e6/9de29bb2d1d6434b8b29ae775ad8c2e48c5391": "c70c34cbeefd40e7c0149b7a0c2c64c2",
".git/objects/ec/a57f232b37fc77fdf12a64c34a4e9318419881": "90813d9fd69419628819aee473988375",
".git/objects/f5/978d22507d8251b9fd70053eba6d4db68b321c": "43fb4a16d94d7ebce9d97e6e50f2c17b",
".git/objects/f7/4f9dfdd6c17b5345888cd0a2119bb443867e91": "a0e2a0914866143189a42cd3b203d88d",
".git/objects/fe/2bfcf95c1c341704e5d266a433b006efec5617": "19c6f6427a9329c00cc6642a04660850",
".git/refs/heads/master": "1af8bafbc7c1e6c6921e658232a4d619",
".git/refs/remotes/origin/pages": "1af8bafbc7c1e6c6921e658232a4d619",
"assets/AssetManifest.json": "0df3c5518d91a0507dd2c1ebf749b217",
"assets/FontManifest.json": "c439c8f7285700f2fce8456b4c7c7d5c",
"assets/fonts/Clicker.ttf": "49a45990bcdd892257d15fca960565ff",
"assets/fonts/MaterialIcons-Regular.otf": "1288c9e28052e028aba623321f7826ac",
"assets/NOTICES": "8a4018889de578f80a132b0ed2def391",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "b14fcf3ee94e3ace300b192e9e7c8c5d",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"index.html": "b02072cd337cf7e0cbb2e1915a3cb674",
"/": "b02072cd337cf7e0cbb2e1915a3cb674",
"main.dart.js": "fe083b496cd6e92c67d9112ec2884d70",
"manifest.json": "0613ebd9273379c3cc2198b0cea6033e",
"version.json": "b3c5a52d40c9472b60ebcd8d7ed21f46"
};

// The application shell files that are downloaded before a service worker can
// start.
const CORE = [
  "/",
"main.dart.js",
"index.html",
"assets/NOTICES",
"assets/AssetManifest.json",
"assets/FontManifest.json"];
// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value + '?revision=' + RESOURCES[value], {'cache': 'reload'})));
    })
  );
});

// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});

// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache.
        return response || fetch(event.request).then((response) => {
          cache.put(event.request, response.clone());
          return response;
        });
      })
    })
  );
});

self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});

// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey in Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}

// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
