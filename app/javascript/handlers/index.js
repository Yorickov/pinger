import testPinger from './testPinger';

export default () => {
  document.addEventListener('turbolinks:load', () => {
    testPinger();
  });
}
