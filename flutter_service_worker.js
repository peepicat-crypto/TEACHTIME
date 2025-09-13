'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "5ef36852213898434f1dae24a3819e0d",
"assets/AssetManifest.bin.json": "ad7e1154c4b9121169b3b919755eb0e3",
"assets/AssetManifest.json": "3fa6ea14d37c19b682f242f6a9382b4b",
"assets/assets/images/profiles/teacher_10.jpg": "54faffd419924f2c34b8a21798b10690",
"assets/assets/images/profiles/teacher_11.jpg": "41f086bd3068687f7f58230334e01a7b",
"assets/assets/images/profiles/teacher_12.jpg": "efcc44b2f8167a2d25f161169539b774",
"assets/assets/images/profiles/teacher_13.jpg": "98a374460bd8ff0298ace117017277a8",
"assets/assets/images/profiles/teacher_14.jpg": "8d08571d86734896eeb6e9ab8ebf5eb5",
"assets/assets/images/profiles/teacher_15.jpg": "26d76c2ffefbdb38dc2ba0ea0ce4a121",
"assets/assets/images/profiles/teacher_16.jpg": "47efa59c92825035ca5ac5f1695efdaa",
"assets/assets/images/profiles/teacher_17.jpg": "75c30c1eb0ad4417e3eeced1d0e4fbc5",
"assets/assets/images/profiles/teacher_18.jpg": "6afbc0029fd304b04dcc6831cf178216",
"assets/assets/images/profiles/teacher_19.jpg": "6e5021e1c0b4be2df9cecfe4434639b4",
"assets/assets/images/profiles/teacher_20.jpg": "77b9e5fb2f6ddb8b0e05e1fa5e1e8f94",
"assets/assets/images/profiles/teacher_21.jpg": "17a8ef1ddc6075af7f18f78eec5cfcfd",
"assets/assets/images/profiles/teacher_22.jpg": "fa7ff470659767058de4cbbe810cedc9",
"assets/assets/images/profiles/teacher_23.jpg": "b0afa4562c422055c5e2982ce49ee81b",
"assets/assets/images/profiles/teacher_24.jpg": "d3036f6cfa7d487af2655f941695dc9d",
"assets/assets/images/profiles/teacher_25.jpg": "09e1f27bace89a4684b1c95ced92e9dc",
"assets/assets/images/profiles/teacher_26.jpg": "dd1204c6ad3fbe4e163ad4eec49b0a71",
"assets/assets/images/profiles/teacher_27.jpg": "ec4ced14c1c9d1f9b23764755487df03",
"assets/assets/images/profiles/teacher_28.jpg": "7b1896b2a5c39df881a4f4adc91d95b5",
"assets/assets/images/profiles/teacher_29.jpg": "d9a389fcbbf9b8711e694e5d56a58c2f",
"assets/assets/images/profiles/teacher_30.jpg": "a603edec59a09a65c7b1eb745fa36e8d",
"assets/assets/images/profiles/teacher_31.jpg": "06b5e855681ebd98a6a90f8afb297018",
"assets/assets/images/profiles/teacher_32.jpg": "290c588072f26cb64c879819086182d9",
"assets/assets/images/profiles/teacher_5.jpg": "327f41455a63715f9c843976a95cfee0",
"assets/assets/images/profiles/teacher_6.jpg": "06ed5883b29e28f047d40e78e7f3081b",
"assets/assets/images/profiles/teacher_7.jpg": "72a8e17b267ed0591ce931d90abef82a",
"assets/assets/images/profiles/teacher_8.jpg": "1195d28588b3272dd79fc0589148862d",
"assets/assets/images/profiles/teacher_9.jpg": "31da3add9496cb2070496830088efd46",
"assets/assets/images/rooms/room_1.jpg": "6fc3983eef7fc0c0002558065e31b55d",
"assets/assets/images/rooms/room_11.jpg": "c3c3f31f089606af1ba40d2358246385",
"assets/assets/images/rooms/room_12jpg.jpg": "6d778a4332c491d83c8e5b131449a705",
"assets/assets/images/rooms/room_13.jpg": "e57b58af5377e77de4bb5e50c6490f1c",
"assets/assets/images/rooms/room_15.jpg": "ad3a66ad5f4dfa993b40e23225e32d06",
"assets/assets/images/rooms/room_16.jpg": "d7c2866c2ab0a5e7bbdc720482978267",
"assets/assets/images/rooms/room_19.jpg": "2cf169e48b2b95c4c234ae603c202c45",
"assets/assets/images/rooms/room_2.jpg": "7ca423dde7abc34d254be8a6dfdeeb56",
"assets/assets/images/rooms/room_20.jpg": "fdd50753c6d3175f0ed3d18174f8aa9a",
"assets/assets/images/rooms/room_21.jpg": "acc6b3e808cc57c9d0b61b73c7b3cb38",
"assets/assets/images/rooms/room_3.jpg": "7accbfca48117617686bca13103c5256",
"assets/assets/images/rooms/room_4.jpg": "8723772d952c1b4728084a705ceb2292",
"assets/assets/images/rooms/room_5.jpg": "fcef7e66e4b9d106cbeec3114ca25f35",
"assets/assets/images/rooms/room_6.jpg": "3b4197ac96c2baf97e55e631b78e786b",
"assets/assets/images/rooms/room_8.jpg": "c72ae4c6717175d2839ff35c071f8846",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "26c3bc7ce97811c94616a7ea81451b89",
"assets/NOTICES": "504d044c346a1f39b0de272233068d20",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"flutter_bootstrap.js": "ff9fd67e7c0e755008952030f23ab66f",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "b7276266142f4b4763008b0bf7729430",
"/": "b7276266142f4b4763008b0bf7729430",
"main.dart.js": "9ba1884f1dc1f0a25544214b282eae7f",
"manifest.json": "835a94fea64b947f3ce82bbebb9552c9",
"version.json": "fa9c046845ad0620fed56e260ff08799"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
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
        // Claim client to enable caching on first launch
        self.clients.claim();
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
      // Claim client to enable caching on first launch
      self.clients.claim();
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
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
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
  for (var resourceKey of Object.keys(RESOURCES)) {
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
