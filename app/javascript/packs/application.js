import Rails from '@rails/ujs';
import Turbolinks from 'turbolinks';
import * as ActiveStorage from '@rails/activestorage';
import 'channels';
import 'chartkick/chart.js';

import '../bootstrap_js_files.js';
import handlers from '../handlers';

Rails.start();
Turbolinks.start();
ActiveStorage.start();

handlers();
