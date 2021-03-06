// Written by Christopher E. Miller
// See the included license.txt for copyright and license details.

module dfl.commondialog;

import core.sys.windows.windows;

import dfl.exception;
import dfl.application;
import dfl.base;
import dfl.control;
import dfl.drawing;
import dfl.event;

abstract class CommonDialog {

   abstract void reset();

   // Uses currently active window of the application as owner.
   abstract DialogResult showDialog();

   abstract DialogResult showDialog(IWindow owner);

   Event!(CommonDialog, HelpEventArgs) helpRequest;

   // See the CDN_* Windows notification messages.
   LRESULT hookProc(HWND hwnd, UINT msg, WPARAM wparam, LPARAM lparam) {
      if (msg == WM_NOTIFY) {
         NMHDR* nmhdr;
         nmhdr = cast(NMHDR*) lparam;
         if (nmhdr.code == CDN_HELP) {
            Point pt;
            GetCursorPos(&pt.point);
            onHelpRequest(new HelpEventArgs(pt));
         }
      }
      return 0;
   }

   void onHelpRequest(HelpEventArgs ea) {
      helpRequest(this, ea);
   }

   abstract bool runDialog(HWND owner);

   package final void _cantrun() {
      throw new DflException("Error running dialog");
   }
}
