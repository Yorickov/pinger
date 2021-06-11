export default (event) => {
  const { target, detail } = event;
  if (!target.classList.contains('ping-link')) {
    return;
  }

  const [data, _status, _xhr] = detail;
  const { message } = data;
  if (message) {
    const pingBoxNode = document.querySelector('.ping-wrapper .ping-box');
    const errorNode = `<div>${message}</div>`
    pingBoxNode.insertAdjacentHTML('afterEnd', errorNode);
  }
};
