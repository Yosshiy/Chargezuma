using UnityEngine;

namespace Chargezuma.Gimmick
{
    /// <summary>
    /// ギミックの基底クラス
    /// </summary>
    public abstract class AGimmick : MonoBehaviour
    {
        /// <summary>
        /// 呼び出し元
        /// TODO : 呼び出し元が拡大する可能性があるので拡張
        /// </summary>
        protected virtual void OnTriggerEnter(Collider other)
        {
            PlayAction();
        }

        /// <summary>
        /// このメソッドをオーバーライドして処理を記載
        /// </summary>
        protected abstract void PlayAction();
    }
}