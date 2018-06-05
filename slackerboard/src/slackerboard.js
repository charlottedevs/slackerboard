export function slackerboardHandler(data, key) {
  /* eslint-disable */
  console.log(`slackerboard_change (${key})->`, data);
  const { slackerboard } = data;
  if (slackerboard) {
    localStorage.setItem(key, JSON.stringify(slackerboard));
    this[key] = slackerboard;
  }

  this.stopLoading(1250);
}


export default slackerboardHandler;
