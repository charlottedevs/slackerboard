const punycode = require('punycode');
const twemoji = require('twemoji');
const regularEmoji = require('../config/emoji/emoji.json');
const customEmoji = require('../config/emoji/custom_emoji.json');

const SKIN_VARIATIONS = {
  2: '1F3FB', // light
  3: '1F3FC', // medium-light
  4: '1F3FD', // medium
  5: '1F3FE', // medium-dark
  6: '1F3FF', // dark
};

function buildEmojiIMG(obj) {
  return `<img class="emoji" src=${obj.path} title=${obj.shortname} alt=${obj.shortname}>`;
}

function buildTwemoji(unified, shortname) {
  const points = unified.split('-').map(p => parseInt(p, 16));
  const unicode = punycode.ucs2.encode(points);
  let img = twemoji.parse(unicode);

  if ((/^<img\s/).test(img)) {
    // add title attribute
    const arr = img.split(' ');
    arr.splice(2, 0, `title=${shortname}`);
    img = arr.join(' ');
  }

  return img;
}

function slackEmoji(rawEmojiName) {
  const toneMatch = rawEmojiName.match(/skin-tone-(\d)/);
  // example:
  // raised_hands::skin-tone-6
  const shortname = rawEmojiName.split('::')[0];
  const ed = regularEmoji.find(el => el.short_name === shortname);

  let result = shortname;

  if (ed) {
    let { unified } = ed;

    if (toneMatch) {
      const variation = SKIN_VARIATIONS[toneMatch[1]];
      unified = ed.skin_variations[variation].unified;
    }
    result = buildTwemoji(unified, rawEmojiName);
  } else {
    const custom = customEmoji.find(el => el.shortname === shortname);
    result = custom ? buildEmojiIMG(custom) : shortname;
  }

  return result;
}

export default { slackEmoji };
