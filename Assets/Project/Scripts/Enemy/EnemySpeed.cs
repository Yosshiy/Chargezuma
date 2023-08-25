using System;
using UnityEngine;

namespace Chargezuma.Enemy {

    /// <summary>
    /// 触れると加速するエネミー
    /// </summary>
    public class EnemySpeed : EnemyCore
    {
        PlayerCollider Collider;

        protected override void OnTriggerEnter(Collider other)
        {
            try
            {
                if(Collider == null)
                {
                    Collider = other.GetComponent<PlayerCollider>();
                }
            }
            catch (NullReferenceException e)
            {
                Debug.LogError(e);
                Debug.Log("プレイヤーにPlayerColliderがアタッチされていません");
            }

            PlayAction();
        }

        /// <summary>
        /// 加速メソッド
        /// </summary>
        protected override void PlayAction()
        {
            Collider.OnAcceleration();
        }

    }
}
