import _ from 'lodash';

export default (event) => {
  const { target, detail } = event;
  if (!target.classList.contains('ping-link')) {
    return;
  }

  event.preventDefault();

  const [data, _status, _xhr] = detail;
  const { status, response_message, response_time } = data;
  const pingBoxNode = document.querySelector('.ping-wrapper .ping-box');
  if (pingBoxNode.children.length > 0) {
    pingBoxNode.innerHTML = '';
  }

  const pingInfoNode = document.createElement('div');
  const baseClasses = ['mb-3', 'card-text'];
  const optClass = status == 'success' ? 'text-success' : 'text-danger';
  pingInfoNode.classList.add(...baseClasses, optClass);

  const optContent = status === 'success' ? `. Response time: ${response_time}` : '';
  const content = `${_.capitalize(status)}: ${_.truncate(response_message, { length: 30 })}${optContent}`;
  pingInfoNode.textContent = content;

  pingBoxNode.append(pingInfoNode);
};
